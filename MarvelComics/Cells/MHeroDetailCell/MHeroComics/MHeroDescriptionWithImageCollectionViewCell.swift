//
//  MHeroDescriptionWithImageCollectionViewCell.swift
//  MarvelComics
//
//  Created by Manish Tamta on 22/05/2022.
//

import UIKit

class MHeroDescriptionWithImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var marvelImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code\
    }

    var model: MarvelCharacterModel? {
        didSet {
            guard let model = model else {
                return
            }
            titleLabel.text = model.name ?? ""
            marvelImageView.downloadImage(from: model.thumbnail?.imageString, placeholderImage: nil)
        }
    }
}

extension MHeroDescriptionWithImageCollectionViewCell {
    
    static func heroComicSectionLayout() ->  NSCollectionLayoutSection {
        let heightDimension = NSCollectionLayoutDimension.estimated(500)

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: heightDimension)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)        
        return section
    }
}
