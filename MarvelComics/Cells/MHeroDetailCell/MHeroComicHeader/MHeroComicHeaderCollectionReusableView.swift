//
//  MHeroComicHeaderCollectionReusableView.swift
//  MarvelComics
//
//  Created by Manish Tamta on 22/05/2022.
//

import UIKit

class MHeroComicHeaderCollectionReusableView: UICollectionReusableView {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setTitle(text: String) {
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: self.frame.width, height: self.frame.height))
        label.text = text
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        self.addSubview(label)
    }
    
}
