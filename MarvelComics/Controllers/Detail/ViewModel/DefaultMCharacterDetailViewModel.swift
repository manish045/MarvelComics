//
//  DefaultMCharacterDetailViewModel.swift
//  MarvelComics
//
//  Created by Manish Tamta on 21/05/2022.
//

import Foundation

protocol InputMCharacterDetailViewModel {
    
}

protocol OutputMCharacterDetailViewModel {
    var marvelCharacterModel: MarvelCharacterModel {get}
}

protocol MCharacterDetailViewModel: InputMCharacterDetailViewModel, OutputMCharacterDetailViewModel {}

final class DefaultMCharacterDetailViewModel: MCharacterDetailViewModel {
    
    var marvelCharacterModel: MarvelCharacterModel
    
    init(marvelCharacterModel: MarvelCharacterModel) {
        self.marvelCharacterModel = marvelCharacterModel
    }
    
}
