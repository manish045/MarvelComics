//
//  HomeViewController.swift
//  Marvel Comics
//
//  Created by Manish Tamta on 19/05/2022.
//

import UIKit
import Combine

class MarvelCharacterListViewController: BaseVC {
    
    var viewModel: DefaultMarvelCharacterListViewModel!
    private var disposeBag = Set<AnyCancellable>()

    @IBOutlet weak var collectionView: UICollectionView!
    
    private lazy var datasource = DiffableDatasource<MarvelCharacterSection, CharacterItem>(collectionView: collectionView!, scheduler: self.scheduler)
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
        // Do any additional setup after loading the view.
        title = "Marvel Characters"
        configureCollectionView()
        configureSearchBar()
        createSnapshot(characterList: [], state: .loading)
        addObservers()
        viewModel.fetchMarvelCharacters()
        self.createStateView(view: self.collectionView)
        
    }
    
    // Add observers from ViewModel to load data whenever change
    private func addObservers() {
        viewModel.loadDataSource
            .receive(on: scheduler.ui)
            .sink { [weak self] (showLoader, charactesList) in
                guard let self = self else {return}
                let state: LoadingState = showLoader ? .loading : .completed
                self.createSnapshot(characterList: charactesList, state: state)
            }
            .store(in: &disposeBag)
        
        viewModel.didGetError
            .receive(on: scheduler.ui)
            .sink { [weak self] (error, characterList) in
                guard let self = self else {return}

                (characterList.count <= 0) ? self.showErrorScreen(error: error) : (self.createSnapshot(characterList: characterList, state: .completed))
            }
            .store(in: &disposeBag)
        
        viewModel.searchTextSubject
            .debounce(for: 0.2, scheduler: scheduler.ui)
            .sink { [weak self] (charactesList) in
                guard let self = self else {return}
                self.createSnapshot(characterList: charactesList, state: .completed)
            }
            .store(in: &disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    //Register Cells for collectionView
    private func configureCollectionView() {
        collectionView.registerNibCell(ofType: HeoresCollectionViewCell.self)
    }
    
    //MARK :- Create and construct a section snapshot, then apply to `main` section in data source.
    func createSnapshot(characterList: [MarvelCharacterModel], state: LoadingState) {
        var snapshot = datasource.snapshot()
        snapshot.deleteAllItems()
        
        //Append Section to snapshot
        snapshot.appendSections([.sections(.characters)])
        
        //Serialize data according to cell model
        let nowPlayingItems: [ItemHolder<CharacterItem>] = characterList.map{.items(.resultItem($0))}
        
        //Append cell to desired section
        snapshot.appendItems(nowPlayingItems, toSection: .sections(.characters))
        
        if state == .default || state == .loading{
            snapshot.appendSections([.loading])
            let loadingItem = LoadingItem(state: state)
            snapshot.appendItems([.loading(loadingItem)], toSection: .loading)
        }
        
        //Apply snapshot to datasource to reload data in collectionView
        datasource.apply(snapshot)
    }
    
    //Add SearchBar to NavigationBar
    private func configureSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsScopeBar = true
        searchController.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    func showErrorScreen(error: APIError) {
        switch error {
        default:
            stateView?.setStateNoDataFound(title: error.asString)
        }
    }
}

extension MarvelCharacterListViewController: UISearchResultsUpdating {

    //MARK :- Get updated search result from Searchbar
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filterListForSearchBar(string: searchController.searchBar.text ?? "")
    }
    
}

extension MarvelCharacterListViewController: UIScrollViewDelegate {
    
    //Determine the scroll direction of collectionView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.size.height {
            viewModel.loadNextPage()
        }
    }
}

extension MarvelCharacterListViewController: UICollectionViewDelegate {
    
    // Push to the cell data when pressed
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? HeoresCollectionViewCell else {return}
        if let model = cell.marvelCharacterModel {
            self.viewModel.pushToCharacterDetailScreen(model: model)
        }
    }
}
