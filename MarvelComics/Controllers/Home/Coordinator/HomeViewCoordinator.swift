//
//  HomeViewCoordinator.swift
//  Marvel Comics
//
//  Created by Manish Tamta on 19/05/2022.
//

import UIKit

protocol HomeViewCoordinatorInput {
    func pushToDetail(model: MarvelCharacterModel)
}

class HomeViewCoordinator: Coordinator, HomeViewCoordinatorInput {
    
    var rootController: UIViewController?
    
    func makeModule() -> UIViewController {
        let vc = createViewController()
        rootController = vc
        return vc
    }
    
    private func createViewController() -> HomeViewController {
        // initializing view controller
        let view = HomeViewController.instantiateFromStoryboard()
        let viewModel = DefaultHomeViewModel(coordinator: self)
        view.viewModel = viewModel
        return view
    }
    
    func pushToDetail(model: MarvelCharacterModel) {
        let vc = MCharacterDetailCoordinator()
            .makeModule(model: model)
        rootController?.navigationController?.present(vc, animated: true, completion: nil)
    }
}
