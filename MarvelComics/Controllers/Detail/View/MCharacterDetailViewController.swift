//
//  MCharacterDetailViewController.swift
//  MarvelComics
//
//  Created by Manish Tamta on 21/05/2022.
//

import UIKit
import Combine

class MCharacterDetailViewController: BaseVC {

    var viewModel: DefaultMCharacterDetailViewModel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var disposeBag = Set<AnyCancellable>()
    
    private lazy var datasource = DiffableDatasource<MCharacterDetailSection, CharacterDetailItem>(collectionView: collectionView!, scheduler: scheduler)
    { [unowned self] (collectionView, indexPath, item) -> UICollectionViewCell? in
        switch item {
        case .characterDetailItem(let model):
            let cell = collectionView.dequeueCell(MHeroDescriptionWithImageCollectionViewCell.self, indexPath: indexPath)
            cell.model = model
            return cell
        case .comicsCharcterInItem(let comicModel):
            let cell = collectionView.dequeueCell(MHeroComicCollectionViewCell.self, indexPath: indexPath)
            cell.model = comicModel
            return cell
        }
    } supplementaryViewProvider: {
        [unowned self] (collectionView, kind, indexPath, section) -> UICollectionReusableView? in
        guard kind == UICollectionView.elementKindSectionHeader else {
            return nil
        }
        //Add header to Section
        switch MCharacterDetailSection(rawValue: indexPath.section) {
        case .comicsForCharater:
            let view = collectionView.dequeueReusableSupplementaryView(MHeroComicHeaderCollectionReusableView.self, kind: kind, indexPath: indexPath)
            view.setTitle(text: "Comics List")
            return view
        case .characterImageAndDescription:
            return nil
        case .none:
            break
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = viewModel.marvelCharacterModel.name
        configureCollectionView()
        createSnapshot(marvelCharacter: viewModel.marvelCharacterModel, comicsForCharacter: [])
        viewModel.fetchComics()
        addViewModelObservers()
    }
    
    // Add observers from ViewModel to load data whenever change
    private func addViewModelObservers() {
        viewModel.loadDataSource
            .receive(on: scheduler.ui)
            .sink { [weak self] modelList in
                guard let self = self else {return}
                self.createSnapshot(marvelCharacter: self.viewModel.marvelCharacterModel,
                                    comicsForCharacter: modelList)
            }
            .store(in: &disposeBag)
    }
    
    //Register Cells for collectionView
    private func configureCollectionView() {
        collectionView.registerNibCell(ofType: MHeroComicCollectionViewCell.self)
        collectionView.registerNibCell(ofType: MHeroDescriptionWithImageCollectionViewCell.self)
        collectionView.registerHeader(ofType: MHeroComicHeaderCollectionReusableView.self)
    }
    
    //MARK :- Create and construct a section snapshot, then apply to `main` section in data source.
    func createSnapshot(marvelCharacter: MarvelCharacterModel, comicsForCharacter: ComicModelList) {
        var snapshot = datasource.snapshot()
        snapshot.deleteAllItems()
        
        //Append Section to snapshot
        snapshot.appendSections([.sections(.characterImageAndDescription)])
        
        //Serialize data according to cell model
        let characterDetail: ItemHolder<CharacterDetailItem> = .items(.characterDetailItem(marvelCharacter))
        
        //Append cell to desired section
        snapshot.appendItems([characterDetail], toSection: .sections(.characterImageAndDescription))
        
        
        snapshot.appendSections([.sections(.comicsForCharater)])
        let nowPlayingItems: [ItemHolder<CharacterDetailItem>] = comicsForCharacter.map{.items(.comicsCharcterInItem($0))}
        snapshot.appendItems(nowPlayingItems, toSection: .sections(.comicsForCharater))
        
        //Apply snapshot to datasource to reload data in collectionView
        datasource.apply(snapshot, animatingDifferences: true)
    }
    
}
