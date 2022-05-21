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
    var preloadedDataModel: PreLoadedDataModel {get}
}

protocol MCharacterDetailViewModel: InputMCharacterDetailViewModel, OutputMCharacterDetailViewModel {}

final class DefaultMCharacterDetailViewModel: MCharacterDetailViewModel {
    
    var preloadedDataModel: PreLoadedDataModel
    
    init(preloadedDataModel: PreLoadedDataModel) {
        self.preloadedDataModel = preloadedDataModel
    }
    
}
