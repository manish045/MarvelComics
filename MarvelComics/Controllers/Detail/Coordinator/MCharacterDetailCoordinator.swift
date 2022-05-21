//
//  MCharacterDetailCoordinator.swift
//  MarvelComics
//
//  Created by Manish Tamta on 21/05/2022.
//

import UIKit

protocol MCharacterDetailCoordinatorInput {
    
}

class MCharacterDetailCoordinator: Coordinator {
    var rootController: UIViewController?
    
    init() {}
    
    func makeModule(model: PreLoadedDataModel) -> UIViewController {
        let vc = createViewController(model: model)
        rootController = vc
        return vc
    }
    
    private func createViewController(model: PreLoadedDataModel) -> MCharacterDetailViewController {
        // initializing view controller
        let view = MCharacterDetailViewController.instantiateFromStoryboard()
        let viewModel = DefaultMCharacterDetailViewModel(preloadedDataModel: model)
        view.viewModel = viewModel
        return view
    }
}
