//
//  APIService+URL.swift
//  Marvel Comics
//
//  Created by Manish Tamta on 20/05/2022.
//

import Foundation
import Alamofire

enum APIEnvironment {
    case staging
    case production
    
    var baseURL: String {
        switch self {
        case .staging:
            return "https://gateway.marvel.com:443/"
        case .production:
            return ""
        }
    }
}

enum EndPoints {
    case characters
    
    var url: String {
        switch self {
        case .characters:
            return "v1/public/characters"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
}

extension APIMarvelService {
    struct URLString {
        private static let environment = APIEnvironment.staging
        static var base: String { environment.baseURL }
    }
    
    static func URL(_ endPoint: EndPoints) -> String {
        return URLString.base + endPoint.url
    }
}

