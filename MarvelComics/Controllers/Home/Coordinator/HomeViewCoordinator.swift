//
//  HomeViewCoordinator.swift
//  Marvel Comics
//
//  Created by Manish Tamta on 19/05/2022.
//

import UIKit


class HomeViewCoordinator: Coordinator {
    var rootController: UINavigationController?
    
    func makeModule() -> UIViewController {
        let vc = createViewController()
        return vc
    }
    
    func start(from presentingController: UINavigationController) {
        rootController = presentingController
    }
    
    private func createViewController() -> HomeViewController {
        // initializing view controller
        return HomeViewController()
    }
}
