//
//  HomeViewCoordinator.swift
//  Marvel Comics
//
//  Created by Manish Tamta on 19/05/2022.
//

import UIKit

protocol MarvelCharacterListCoordinatorInput {
    func pushToDetail(model: MarvelCharacterModel)
}

class MarvelCharacterListCoordinator: Coordinator, MarvelCharacterListCoordinatorInput {
    
    var rootController: UIViewController?
    
    func makeModule() -> UIViewController {
        let vc = createViewController()
        return vc
    }
    
    private func createViewController() -> MarvelCharacterListViewController {
        // initializing view controller
        let view = MarvelCharacterListViewController.instantiateFromStoryboard()
        let viewModel = DefaultMarvelCharacterListViewModel(coordinator: self)
        view.viewModel = viewModel
        return view
    }
    
    func start(from presentingController: UIViewController) {
        rootController = presentingController
    }
    
    func pushToDetail(model: MarvelCharacterModel) {
        let vc = MCharacterDetailCoordinator()
            .makeModule(model: model)
        rootController?.navigationController?.present(vc, animated: true, completion: nil)
    }
}
