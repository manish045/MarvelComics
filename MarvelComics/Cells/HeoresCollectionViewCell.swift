//
//  HeoresCollectionViewCell.swift
//  MarvelComics
//
//  Created by Manish Tamta on 19/05/2022.
//

import UIKit

class HeoresCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        characterImageView.layer.cornerRadius = characterImageView.frame.height/2
        characterImageView.layer.borderColor = UIColor.black.cgColor
        characterImageView.layer.borderWidth = 1
    }

    var marvelCharacterModel: MarvelCharacterModel! {
        didSet {
            characterNameLabel.text = marvelCharacterModel.name
            characterImageView.downloadImage(from: marvelCharacterModel.characterImage, placeholderImage: UIImage(named: ""))
        }
    }
}
