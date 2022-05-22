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
    @IBOutlet weak var characterDescriptionLabel: UILabel!
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var nameBackgroundView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellBackgroundView.setCornerRadius(12)
    }

    var marvelCharacterModel: MarvelCharacterModel! {
        didSet {
            characterNameLabel.text = marvelCharacterModel.name
            self.characterDescriptionLabel.text = marvelCharacterModel.resultDescription
            characterImageView.downloadImage(from: marvelCharacterModel.thumbnail?.imageString, placeholderImage: UIImage(named: ""))
        }
    }
}

extension HeoresCollectionViewCell {
    
    static var heroCollectionSectionLayout:  NSCollectionLayoutSection {
        let heightDimension = NSCollectionLayoutDimension.absolute(230)

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: heightDimension)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets.bottom = 15

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets.leading = 15
        group.contentInsets.trailing = 15

        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}
