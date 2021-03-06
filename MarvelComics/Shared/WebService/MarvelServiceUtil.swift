//
//  MarvelServiceUtil.swift
//  MarvelComics
//
//  Created by Manish Tamta on 21/05/2022.
//

import Foundation
import CryptoKit


enum KeyString: String {
    case publicKey
    case privateKey
}


struct MSUtils {
    
    func buildServiceRequestUrl(baseUrl: String) -> String? {
        if var urlComponents = URLComponents(string: baseUrl) {
            let ts = "\(Int((Date().timeIntervalSince1970 * 1000.0).rounded()))"
            
            guard let publicKey = getAPIKeys()[KeyString.publicKey.rawValue] as? String, let privateKey = getAPIKeys()[KeyString.privateKey.rawValue] as? String else {return nil}
            
            let privateKeyMd5 = MD5Hex(string: "\(ts)\(privateKey)\(publicKey)")
            
            //addd auth params
            var requestParams = [String : String]()
            requestParams["ts"] = ts
            requestParams["apikey"] = publicKey
            requestParams["hash"] = privateKeyMd5
            
            //build query string
            var queryItems = [URLQueryItem]()
            for (key, value) in requestParams {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
            
            urlComponents.queryItems = queryItems
            
            if let urlAbsoluteString = urlComponents.url?.absoluteString {
                return urlAbsoluteString
            }
        }
        
        return nil
    }

    //MARK:- Get Keys from Marvel Plist file
    func getAPIKeys() -> [String: Any] {
        if let path = Bundle.main.path(forResource: "MarvelPlist", ofType: "plist") {
            let plist = NSDictionary(contentsOfFile: path) ?? ["":""]
            let publicKey = plist[KeyString.publicKey.rawValue] as! String
            let privateKey = plist[KeyString.privateKey.rawValue] as! String
            let dict = [KeyString.publicKey.rawValue: publicKey, KeyString.privateKey.rawValue: privateKey]
            return dict
            
        }
        return ["": ""]
    }
    
    /*
     There are two steps:
     1. Create md5 data from a string
     2. Covert the md5 data to a hex string
     */
    func MD5Hex(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
        return digest.map {
                String(format: "%02hhx", $0)
            }.joined()
    }
}
