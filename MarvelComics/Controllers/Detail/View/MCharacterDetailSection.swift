//
//  MCharacterDetailSection.swift
//  MarvelComics
//
//  Created by Manish Tamta on 21/05/2022.
//

import UIKit

enum MCharacterDetailSection: Int {
    case comicsForCharater
}

enum CharacterDetailItem: Hashable {
    case comicsCharcterInItem(ComicsItem)
}

extension MCharacterDetailSection: Sectionable {
    func layout(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        switch self {
        case .comicsForCharater:
            return MHeroComicCollectionViewCell.heroComicSectionLayout(headerHeight: 40)
        }
    }
}
