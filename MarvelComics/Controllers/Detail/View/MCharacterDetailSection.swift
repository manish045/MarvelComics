//
//  MCharacterDetailSection.swift
//  MarvelComics
//
//  Created by Manish Tamta on 21/05/2022.
//

import UIKit

enum MCharacterDetailSection: Int {
    case characterImageAndDescription
    case comicsForCharater
}

enum CharacterDetailItem: Hashable {
    case characterDetailItem(MarvelCharacterModel)
    case comicsCharcterInItem(ComicsModel)
}

extension MCharacterDetailSection: Sectionable {
    func layout(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        switch self {
        case .comicsForCharater:
            return MHeroComicCollectionViewCell.heroComicSectionLayout(heightDimension: .absolute(289), widthDimension: .absolute(170))
        case .characterImageAndDescription:
            return MHeroDescriptionWithImageCollectionViewCell.heroComicSectionLayout()
        }
    }
}
