//
//  SDStateViewExt.swift
//  MarvelComics
//
//  Created by Manish Tamta on 21/05/2022.
//


import Foundation
import UIKit
extension SDStateView {
    func sendBehind(view:UIView){
        self.removeFromSuperview()
        view.addSubview(self)
        self.removeConstraints(self.constraints)
        self.translatesAutoresizingMaskIntoConstraints = false
        self._setWidthEqualTo(view: view, offset: 0)
        self._setHeightEqualTo(view: view, offset: 0)
        self._setCenterAlignWith(view: view)
        self.layoutIfNeeded()
    }
    
    func setDataAvailable(){
        self.isHidden = true
        self.setState(.dataAvailable)
    }
    
    func setStateNoDataFound(title:String? = nil){
        self.isHidden = false
        let titleStr = title ?? "No Data Found"
        self.setState(.withImage(
            image: "no_data",
            title: titleStr,
            message: "")
        )
    }
    
    func setStateLoading(){
        self.isHidden = false
        self.setState(.loading(message: "Loading..." ))
    }
    
    func setNoInternetConnection(withRetry:Bool=true , retryAction:@escaping () -> Void){
        self.isHidden = false
        self.setState(.dataAvailable)
        
        self.setState(.withButton(errorImage: "no_internet", title: "No Internet" , message: "Check your internet connection", buttonTitle: "Try again", buttonConfig: { (button) in
            // You can configure the button here
        }, retryAction: {
            retryAction()
        }))
    }
    
    func setServerError(withRetry:Bool=true, title: String, message: String, retryAction:@escaping () -> Void){
        self.isHidden = false
        self.setState(.withButton(errorImage: "server_error", title: title , message: message, buttonTitle: "Try again" , buttonConfig: { (button) in
            // You can configure the button here
        }, retryAction: {
            retryAction()
        }))
    }
}

