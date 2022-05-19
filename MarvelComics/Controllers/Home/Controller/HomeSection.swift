//
//  HomeSection.swift
//  MarvelComics
//
//  Created by Manish Tamta on 19/05/2022.
//

import UIKit

enum MarvelCharacterSection {
    case characters
    case loader
}

enum CharacterItem: Hashable {
    case resultItem(HomeModel)
    case loading(LoadingItem)
}

extension MarvelCharacterSection: Sectionable {
    func layout(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        switch self {
        case .characters:
            // Section
            let layoutSection = mapSection()
            layoutSection.contentInsets.top = 15
            return layoutSection
        case .loader:
            return LoadingCollectionCell.loadingSectionLayout
        }
    }
    
    fileprivate func mapSection() -> NSCollectionLayoutSection {
        let heightDimension = NSCollectionLayoutDimension.absolute(50)

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
