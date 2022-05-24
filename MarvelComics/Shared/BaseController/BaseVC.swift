//
//  BaseVC.swift
//  MarvelComics
//
//  Created by Manish Tamta on 21/05/2022.
//

import Foundation
import UIKit

class BaseVC: UIViewController {
   
    var stateView:SDStateView?
    let scheduler: SchedulerContext = SchedulerContextProvider.provide()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //Create a new state view
    func createStateView(view: UIView? = nil){
        guard let sourceView = view ?? self.view
            else {return}
        if let stateView = self.stateView {
            stateView.removeFromSuperview()
        }
        self.stateView = SDStateView(frame: sourceView.frame)
        self.stateView?.center = sourceView.center
        self.stateView?.setDataAvailable()
        self.stateView?.sendBehind(view: sourceView)
    }
}
