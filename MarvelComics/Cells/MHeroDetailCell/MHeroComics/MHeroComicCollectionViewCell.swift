//
//  MHeroComicCollectionViewCell.swift
//  MarvelComics
//
//  Created by Manish Tamta on 22/05/2022.
//

import UIKit

class MHeroComicCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var comicLabel: UILabel!
    @IBOutlet weak var comicContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code\
        comicContainerView.layer.cornerRadius = 8
        comicContainerView.layer.borderWidth = 1
        comicContainerView.layer.borderColor = UIColor.black.cgColor
    }

    var model: ComicsItem? {
        didSet {
            guard let model = model else {
                return
            }
            comicLabel.text = model.name
        }
    }
}

extension MHeroComicCollectionViewCell {
    
    static func heroComicSectionLayout(headerHeight: CGFloat = 0) ->  NSCollectionLayoutSection {
        let heightDimension = NSCollectionLayoutDimension.estimated(100)

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: heightDimension)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets.leading = 15
        group.contentInsets.trailing = 15
        
        // This is where the header gets added:
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(headerHeight))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
}
