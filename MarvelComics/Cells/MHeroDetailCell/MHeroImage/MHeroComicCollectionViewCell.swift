//
//  MHeroComicCollectionViewCell.swift
//  MarvelComics
//
//  Created by Manish Tamta on 21/05/2022.
//

import UIKit

class MHeroComicCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var issueNumberLabel: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    //MARK: Render data
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model: ComicsModel? {
        didSet {
            guard let comicModel = model else {
                return
            }
            
            self.thumbnailImage.setCornerRadius(12)
            self.titleLabel.text = comicModel.title
            if let issueNumber = comicModel.issueNumber {
                self.issueNumberLabel.text = "Issue number \(String(describing: issueNumber))"
            }
            self.thumbnailImage.downloadImage(from: comicModel.thumbnail?.imageString, placeholderImage: nil)
        }
    }
}

extension MHeroComicCollectionViewCell {
    
    static func heroComicSectionLayout(heightDimension: NSCollectionLayoutDimension,
                                       widthDimension: NSCollectionLayoutDimension,
                                       headerHeight: NSCollectionLayoutDimension = .absolute(30)) ->  NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(widthDimension:  .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 8, bottom: 0, trailing: 8)

        let groupSize = NSCollectionLayoutSize(widthDimension: widthDimension,
                                               heightDimension: heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // This is where the header gets added:
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: headerHeight)
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        section.orthogonalScrollingBehavior  = .paging
        
        return section
    }
}
