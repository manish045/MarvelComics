//
//  MCharacterDetailViewController.swift
//  MarvelComics
//
//  Created by Manish Tamta on 21/05/2022.
//

import UIKit

class MCharacterDetailViewController: UIViewController {

    var viewModel: DefaultMCharacterDetailViewModel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let scheduler: SchedulerContext = SchedulerContextProvider.provide()
    
    private lazy var datasource = DiffableDatasource<MCharacterDetailSection, CharacterDetailItem>(collectionView: collectionView!, scheduler: scheduler)
    { [unowned self] (collectionView, indexPath, item) -> UICollectionViewCell? in
        switch item {
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
        
        let view = collectionView.dequeueReusableSupplementaryView(MHeroComicHeaderCollectionReusableView.self, kind: kind, indexPath: indexPath) 
        view.setTitle(text: "Comics List")
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = viewModel.marvelCharacterModel.name
        configureCollectionView()
        createSnapshot(comicList: viewModel.marvelCharacterModel.comics?.items ?? [])
    }
    
    private func configureCollectionView() {
        collectionView.registerNibCell(ofType: MHeroComicCollectionViewCell.self)
        collectionView.registerHeader(ofType: MHeroComicHeaderCollectionReusableView.self)
    }
    
    
    func createSnapshot(comicList: [ComicsItem]) {
        var snapshot = datasource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.sections(.comicsForCharater)])
        let nowPlayingItems: [ItemHolder<CharacterDetailItem>] = comicList.map{.items(CharacterDetailItem.comicsCharcterInItem($0))}
        snapshot.appendItems(nowPlayingItems, toSection: .sections(.comicsForCharater))
        datasource.apply(snapshot)
    }
    
}
