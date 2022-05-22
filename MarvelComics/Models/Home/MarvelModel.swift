//
//  MarvelModel.swift
//  Marvel Comics
//
//  Created by Manish Tamta on 19/05/2022.
//

import Foundation

typealias MarvelModelList = [MarvelCharacterModel]

import Foundation

// MARK: - MarvelModel
struct MarvelModel: BaseModel {
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
    let thumbnail: Thumbnail?

    enum CodingKeys: String, CodingKey {
        case id, name
        case resultDescription = "description"
        case thumbnail
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }

    static func == (lhs: MarvelCharacterModel, rhs: MarvelCharacterModel) -> Bool {
      lhs.id == rhs.id
    }
}

// MARK: - Thumbnail
struct Thumbnail: BaseModel {
    private let path: String?
    private let thumbnailExtension: String?
    
    var imageString: String {
        guard let path = path, let thumbnailExtension = thumbnailExtension else {
            return ""
        }
        return (path+"."+thumbnailExtension)
    }

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}
