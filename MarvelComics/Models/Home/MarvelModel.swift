//
//  MarvelModel.swift
//  Marvel Comics
//
//  Created by Manish Tamta on 19/05/2022.
//

import Foundation

typealias MarvelModelList = [MarvelCharacterModel]

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let marvelModel = try? newJSONDecoder().decode(MarvelModel.self, from: jsonData)

import Foundation

// MARK: - MarvelModel
struct MarvelModel: BaseModel {
    let code: Int?
    let status, copyright, attributionText, attributionHTML: String?
    let etag: String?
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: BaseModel {
    let offset, limit, total, count: Int?
    let results: [MarvelCharacterModel]?
}

// MARK: - MarvelCharacterModel
struct MarvelCharacterModel: Hashable, BaseModel {
    let id: Int
    let name, resultDescription: String?
    let modified: Date?
    let thumbnail: Thumbnail?
    let resourceURI: String?
    let comics, series: Comics?
    let stories: Stories?
    let events: Comics?

    enum CodingKeys: String, CodingKey {
        case id, name
        case resultDescription = "description"
        case modified, thumbnail, resourceURI, comics, series, stories, events
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }

    static func == (lhs: MarvelCharacterModel, rhs: MarvelCharacterModel) -> Bool {
      lhs.id == rhs.id
    }
}

// MARK: - Comics
struct Comics: BaseModel {
    let available: Int?
    let collectionURI: String?
    let items: [ComicsItem]?
    let returned: Int?
}

// MARK: - ComicsItem
struct ComicsItem: BaseModel {
    let resourceURI: String?
    let name: String?
}

// MARK: - Stories
struct Stories: BaseModel {
    let available: Int?
    let collectionURI: String?
    let items: [StoriesItem]?
    let returned: Int?
}

// MARK: - StoriesItem
struct StoriesItem: BaseModel {
    let resourceURI: String?
    let name: String?
    let type: String?
}

// MARK: - Thumbnail
struct Thumbnail: BaseModel {
    let path: String?
    let thumbnailExtension: String?

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}