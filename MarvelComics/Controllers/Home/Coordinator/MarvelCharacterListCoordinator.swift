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

/// Coordinator :- Organizing flow logic between view controllers
class MarvelCharacterListCoordinator: Coordinator, MarvelCharacterListCoordinatorInput {
    
    var rootController: UIViewController?
    
    //Create View Controller instance with all possible initialization for viewModel and controller
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
    
    //Pass the navigationController to the initial controller
    func start(from presentingController: UIViewController) {
        rootController = presentingController
    }
    
    func pushToDetail(model: MarvelCharacterModel) {
        let vc = MCharacterDetailCoordinator()
            .makeModule(model: model)
        rootController?.navigationController?.present(vc, animated: true, completion: nil)
    }
}
