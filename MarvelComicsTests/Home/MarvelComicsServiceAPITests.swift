//
//  MarvelComicsServiceAPITests.swift
//  MarvelComicsTests
//
//  Created by Manish Tamta on 19/05/2022.
//

import XCTest
import Alamofire
@testable import MarvelComics

class MarvelComicsServiceAPITests: XCTestCase {
    
    var util: MSUtils!
    var apiService: PerformRequest!
    
    override func setUp() {
        util = MSUtils()
        apiService = APIMarvelService()
    }
    
    //MARK:- Test the get Characters request with passing empty key params.
    func testKeysArePresentInPlistORturnsError() {
        let msUtils = MSUtils()
        
        let getAPIKeys = msUtils.getAPIKeys()
        
        let publicKey = getAPIKeys[KeyString.publicKey.rawValue]
        let privateKey = getAPIKeys[KeyString.publicKey.rawValue]
        
        XCTAssertNotNil(publicKey)
        XCTAssertNotNil(privateKey)
        
        let ts = "\(Int((Date().timeIntervalSince1970 * 1000.0).rounded()))"
        let privateKeyMd5 = msUtils.MD5Hex(string: "\(ts)\(privateKey)\(publicKey)")
        XCTAssertFalse(privateKeyMd5.isEmpty)
    }
    
    //MARK:- Test the get Characters request passing key params.
    func testCharacterListApiResourceWithEmptyStringRturnsError() {
       
        let url = APIMarvelService.URL(.characters)
        let baseURL = util.buildServiceRequestUrl(baseUrl: url)
        XCTAssertNotNil(baseURL?.isEmpty)
    }
    
    
    //MARK:- Test the get Characters requeset
    func testCharacterListApiResourceWithParametersReturnsError() {

        let expectation = self.expectation(description: "testAPICall")
        apiService.performRequest(endPoint: .characters, parameters: [:]) { (result: APIResult<ComicsDataModel, APIError>) in
            switch result {
            case .success(let model):
                XCTAssertNotNil(model)
                expectation.fulfill()
            default:
                break
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    //MARK:- Test the get Characters request with passing empty key params.
    func testCharacterListApiResourceWithEmptyAuthParamsRturnsError() {
      
        let expectation = self.expectation(description: "PassingEmptyAuthKeyParams")
        apiService = FailableServiceAPI()
        apiService.performRequest(endPoint: .characters, parameters: [:]) { (result: APIResult<ComicsDataModel, APIError>) in
            switch result {
            case .error(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            default:
                break
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    override func tearDown() {
        util = nil
        apiService = nil
    }
    
}

class FailableServiceAPI: SessionManager, PerformRequest {
    func performRequest<T>(endPoint: EndPoints, parameters: [String : Any], completion: @escaping (APIResult<T, APIError>) -> Void) where T : BaseModel {
        let url = APIMarvelService.URL(endPoint)
        
        request(url,method: endPoint.httpMethod, parameters: parameters).validate().debugLog().responseDecodable { (response: DataResponse<T>) in
            switch response.result {
            case .success(let parsedModel):
                completion(.success(parsedModel))
            case .failure(let error):
                // incase of logout we will check only status code
                completion(.error(.serverError(error.localizedDescription)))
            }
        }
    }
}



