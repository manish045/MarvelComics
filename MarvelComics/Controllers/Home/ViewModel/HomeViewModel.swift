//
//  HomeViewModel.swift
//  Marvel Comics
//
//  Created by Manish Tamta on 19/05/2022.
//

import Foundation
import Combine
    
protocol HomeViewModelInput {
    func fetchMarvelCharacters()
    func loadNextPage()
    func filterListForSearchBar(string: String)
    func pushToCharacterDetailScreen(model: PreLoadedDataModel)
}

protocol HomeViewModelOutput {
    var loadDataSource: PassthroughSubject<(Bool,MarvelModelList), Never> { get}
    var didGetError: PassthroughSubject<(APIError, MarvelModelList), Never> {get}
    var searchTextSubject: PassthroughSubject<MarvelModelList, Never>{get}

}

protocol MoviesListViewModel: HomeViewModelInput, HomeViewModelOutput {}

final class DefaultHomeViewModel: MoviesListViewModel {
    
    var apiService: APIMarvelService
    var coordinator: HomeViewCoordinatorInput
    
    private var limit = 20
    private var pageOffset = 0

    /*
     Variable manages if more characters are needed to be fetched
     false -> All characters are fetched from server
     true -> There are few more characters that needs to be fetched
     */
    private var loadMoreCharacters = true
    
    //Contains all the characters fetched from the API
    private var marvelCharactersDataSource = MarvelModelList()
        
    //Bool Manages Loader, secondValue manages heroes array, failure block manages Error
    var loadDataSource = PassthroughSubject<(Bool,MarvelModelList), Never>()
    var didGetError = PassthroughSubject<(APIError, MarvelModelList), Never>()
    var searchTextSubject = PassthroughSubject<MarvelModelList, Never>()
    
    //Manages wheather to load next page or not
    private var loadDataOnNextPage = true
    
    init(apiService: APIMarvelService = APIMarvelService.shared,
         coordinator: HomeViewCoordinatorInput) {
        self.apiService = apiService
        self.coordinator = coordinator
    }
    
    func loadNextPage() {
        guard loadDataOnNextPage, marvelCharactersDataSource.count > 0 else {return}
        loadDataOnNextPage = false
        self.fetchMarvelCharacters()
    }
    
    func fetchMarvelCharacters() {
        if !loadMoreCharacters {
            self.loadDataSource.send((self.loadMoreCharacters, self.marvelCharactersDataSource))
            return
        }

        let params = [
            "limit" : limit,
            "offset" : pageOffset,
        ] as [String : Any]
        
        apiService.performRequest(endPoint: .characters, parameters: params) { [weak self] (result: APIResult<MarvelModel, APIError>) in
            switch result {
            case .success(let model):
                guard let self = self else {return}
                self.pageOffset += self.limit
                let total = model.data?.total ?? 0
                self.loadDataOnNextPage = true
                self.loadMoreCharacters = (total >= self.pageOffset)
                self.marvelCharactersDataSource.append(contentsOf: model.data?.results ?? [])
                self.loadDataSource.send((self.loadMoreCharacters, self.marvelCharactersDataSource))
            case .error(let error):
                guard let self = self else {return}
                self.didGetError.send((error, self.marvelCharactersDataSource))
                break
            }
        }
    }
    
    func filterListForSearchBar(string: String) {
        if string.isEmpty {
            searchTextSubject.send(marvelCharactersDataSource)
        }else{
            let filteredArray = self.marvelCharactersDataSource.filter({$0.name?.lowercased().contains(string.lowercased()) as! Bool})
            searchTextSubject.send(filteredArray)
        }        
    }
    
    func pushToCharacterDetailScreen(model: PreLoadedDataModel) {
        self.coordinator.pushToDetail(model: model)
    }
}
