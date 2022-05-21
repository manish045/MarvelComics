//
//  HomeViewController.swift
//  Marvel Comics
//
//  Created by Manish Tamta on 19/05/2022.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    var viewModel: DefaultHomeViewModel!
    private var disposeBag = Set<AnyCancellable>()
    private var state: LoadingState = .loading

    @IBOutlet weak var collectionView: UICollectionView!
    private let scheduler: SchedulerContext = SchedulerContextProvider.provide()
    
    private lazy var datasource = DiffableDatasource<MarvelCharacterSection, CharacterItem>(collectionView: collectionView!, scheduler: scheduler)
    { [unowned self] (collectionView, indexPath, item) -> UICollectionViewCell? in
        switch item {
        case .resultItem(let model):
            let cell = collectionView.dequeueCell(HeoresCollectionViewCell.self, indexPath: indexPath)
            cell.marvelCharacterModel = model
            return cell
        case .loading(let loadingItem):
            let cell = collectionView.dequeueCell(LoadingCollectionCell.self, indexPath: indexPath)
            cell.configure(data: loadingItem)
            return cell
        }
    } supplementaryViewProvider: {
        [unowned self] (collectionView, kind, indexPath, section) -> UICollectionReusableView? in
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Marvel Characters"
        configureCollectionView()
        configureSearchBar()
        createSnapshot(characterList: [])
        addObservers()
        viewModel.fetchMarvelCharacters()
        // Do any additional setup after loading the view.
    }
    
    private func addObservers() {
        viewModel.loadDataSource
            .receive(on: scheduler.ui)
            .sink{ [weak self] (showLoader, charactesList) in
                guard let self = self else {return}
                self.state = showLoader ? .loading : .completed
                self.createSnapshot(characterList: charactesList)
            }
            .store(in: &disposeBag)
        
        viewModel.didGetError
            .receive(on: scheduler.ui)
            .sink { [weak self] (error, charactesList) in
                guard let self = self else {return}
                self.state = .completed
                self.createSnapshot(characterList: charactesList)
            }
            .store(in: &disposeBag)
        
        viewModel.searchTextSubject
            .debounce(for: 0.2, scheduler: scheduler.ui)
            .sink { [weak self] (charactesList) in
                guard let self = self else {return}
                self.state = .completed
                self.createSnapshot(characterList: charactesList)
            }
            .store(in: &disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func configureCollectionView() {
        collectionView.registerNibCell(ofType: HeoresCollectionViewCell.self)
    }
    
    func createSnapshot(characterList: [MarvelCharacterModel]) {
        var snapshot = datasource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.sections(.characters)])
        let nowPlayingItems: [ItemHolder<CharacterItem>] = characterList.map{.items(.resultItem($0))}
        snapshot.appendItems(nowPlayingItems, toSection: .sections(.characters))
        
        if state == .default || state == .loading{
            snapshot.appendSections([.loading])
            let loadingItem = LoadingItem(state: state)
            snapshot.appendItems([.loading(loadingItem)], toSection: .loading)
        }
        datasource.apply(snapshot)
    }
    
    private func configureSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsScopeBar = true
        searchController.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filterListForSearchBar(string: searchController.searchBar.text ?? "")
    }
    
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.size.height {
            viewModel.loadNextPage()
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? HeoresCollectionViewCell else {return}
        if let model = cell.marvelCharacterModel {
            self.viewModel.pushToCharacterDetailScreen(model: model)
        }
    }
}
