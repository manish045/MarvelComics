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

extension HeoresCollectionViewCell {
    
    static var heroCollectionSectionLayout:  NSCollectionLayoutSection {
        let heightDimension = NSCollectionLayoutDimension.absolute(70)

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: heightDimension)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets.bottom = 0

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets.leading = 15
        group.contentInsets.trailing = 15

        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}
