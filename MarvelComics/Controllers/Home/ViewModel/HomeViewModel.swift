//
//  HomeViewModel.swift
//  Marvel Comics
//
//  Created by Manish Tamta on 19/05/2022.
//

import Foundation
    
protocol HomeViewModelInput {}

protocol HomeViewModelOutput {
    
}

protocol MoviesListViewModel: HomeViewModelInput, HomeViewModelOutput {}

final class DefaultHomeViewModel: MoviesListViewModel {
    
}
