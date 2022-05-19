//
//  HomeSection.swift
//  MarvelComics
//
//  Created by Manish Tamta on 19/05/2022.
//

import UIKit

enum MarvelCharacterSection {
    case characters
}

enum CharacterItem: Hashable {
    case resultItem(HomeModel)
}

extension MarvelCharacterSection: Sectionable {
    func layout(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        switch self {
        case .characters:
            // Section
            let layoutSection = mapSection()
            layoutSection.contentInsets.top = 15
            return layoutSection
        }
    }
    
    fileprivate func mapSection() -> NSCollectionLayoutSection {
        /*
         Notice that I estimate my button cell to be 300 points high
         It's way too much. But since it's an estimation and we're doing things well,
         it doesn't really matter to the end result.
        */
        let heightDimension = NSCollectionLayoutDimension.absolute(50)

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: heightDimension)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets.bottom = 0

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets.leading = 0
        group.contentInsets.trailing = 0

        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}
