//
//  MarvelComicModel.swift
//  MarvelComics
//
//  Created by Manish Tamta on 22/05/2022.
//

import Foundation

// MARK: - Decoder

typealias ComicModelList = [ComicsModel]

struct ComicsDataModel: BaseModel {
    var data: ComicsResultModel?
}

struct ComicsResultModel: BaseModel {
    var results: ComicModelList?
}

struct ComicsModel: Hashable, BaseModel {
    
    let id: Int
    var title: String?
    var issueNumber: Int?
    var thumbnail: Thumbnail?
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
    
    static func == (lhs: ComicsModel, rhs: ComicsModel) -> Bool {
        return lhs.title == rhs.title &&
        lhs.issueNumber == rhs.issueNumber &&
        lhs.id == rhs.id
    }
}
