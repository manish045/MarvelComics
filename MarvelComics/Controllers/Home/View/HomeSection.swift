//
//  HomeSection.swift
//  MarvelComics
//
//  Created by Manish Tamta on 19/05/2022.
//

import UIKit

enum MarvelCharacterSection: Int {
    case characters = 0
    case loader
}

enum CharacterItem: Hashable {
    case resultItem(MarvelCharacterModel)
    case loading(LoadingItem)
}

extension MarvelCharacterSection: Sectionable {
    func layout(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        switch self {
        case .characters:
            // Section
            let layoutSection = HeoresCollectionViewCell.heroCollectionSectionLayout
            layoutSection.contentInsets.top = 15
            return layoutSection
        case .loader:
            return LoadingCollectionCell.loadingSectionLayout
        }
    }
}
