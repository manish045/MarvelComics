//
//  LoaderView.swift
//  Blockbuster
//
//  Created by Manish Tamta on 04/04/2022.
//

import UIKit

class LoaderView: NibView {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
}
