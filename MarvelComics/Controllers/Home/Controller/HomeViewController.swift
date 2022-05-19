//
//  HomeViewController.swift
//  Marvel Comics
//
//  Created by Manish Tamta on 19/05/2022.
//

import UIKit

class HomeViewController: UIViewController {
    var viewModel: DefaultHomeViewModel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    let scheduler: SchedulerContext = SchedulerContextProvider.provide()
    
    private lazy var datasource = DiffableDatasource<MarvelCharacterSection, CharacterItem>(collectionView: collectionView!, scheduler: scheduler)
    { [unowned self] (collectionView, indexPath, item) -> UICollectionViewCell? in
        switch item {
        case .resultItem(let model):
            let cell = collectionView.dequeueCell(HeoresCollectionViewCell.self, indexPath: indexPath)
            cell.titleLabel.text = model.name
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
        configureCollectionView()
        createSnapshot(users: getAllData())
        // Do any additional setup after loading the view.
    }
    
    private func configureCollectionView() {
        collectionView.registerNibCell(ofType: HeoresCollectionViewCell.self)
    }
    
    func getAllData() -> [HomeModel] {
        return [
            HomeModel(name: "Person 1"),
            HomeModel(name: "Person 2"),
            HomeModel(name: "Person 3"),
            HomeModel(name: "Person 4"),
            HomeModel(name: "Person 5"),
            HomeModel(name: "Person 6")
        ]
    }
    
    func createSnapshot(users: [HomeModel]){
        var snapshot = datasource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.sections(.characters)])

        let nowPlayingItems: [ItemHolder<CharacterItem>] = users.map{.items(.resultItem($0))}
        snapshot.appendItems(nowPlayingItems, toSection: .sections(.characters))
        
        let state: LoadingState = .loading
        if state == .default || state == .loading {
            snapshot.appendSections([.loading])
            let loadingItem = LoadingItem(state: state)
            snapshot.appendItems([.loading(loadingItem)], toSection: .loading)
        }
        datasource.apply(snapshot)
    }
}
