//
//  DefaultMCharacterDetailViewModel.swift
//  MarvelComics
//
//  Created by Manish Tamta on 21/05/2022.
//

import Foundation
import Combine

protocol InputMCharacterDetailViewModel {
    func fetchComics()
}

protocol OutputMCharacterDetailViewModel {
    var marvelCharacterModel: MarvelCharacterModel {get}
    var loadDataSource: Published<ComicModelList>.Publisher { get }
    var didGetError: PassthroughSubject<APIError, Never> {get}
}

protocol MCharacterDetailViewModel: InputMCharacterDetailViewModel, OutputMCharacterDetailViewModel {}

final class DefaultMCharacterDetailViewModel: MCharacterDetailViewModel {
    
    var marvelCharacterModel: MarvelCharacterModel
    
    @Published private var marvelComicDataSource = ComicModelList()
    var loadDataSource: Published<ComicModelList>.Publisher {$marvelComicDataSource}
    
    private var apiService: PerformRequest
    
    var didGetError = PassthroughSubject<APIError, Never>()
    
    init(marvelCharacterModel: MarvelCharacterModel,
         apiService: PerformRequest = APIMarvelService()) {
        self.marvelCharacterModel = marvelCharacterModel
        self.apiService = apiService
    }
    
    
    func fetchComics() {
        apiService.performRequest(endPoint: .characterComics(id: marvelCharacterModel.id), parameters: [:]) { [weak self] (result: APIResult<ComicsDataModel, APIError>) in
            switch result {
            case .success(let model):
                guard let self = self else {return}
                let comicModelList = model.data?.results
                self.marvelComicDataSource.append(contentsOf: comicModelList ?? [])
            case .error(let error):
                guard let self = self else {return}
                self.didGetError.send(error)
            }
        }
    }
    
}
