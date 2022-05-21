//
//  MCharacterDetailViewController.swift
//  MarvelComics
//
//  Created by Manish Tamta on 21/05/2022.
//

import UIKit

class MCharacterDetailViewController: UIViewController {

    var viewModel: DefaultMCharacterDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = viewModel.preloadedDataModel.name
    }

}
