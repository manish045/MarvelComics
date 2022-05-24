//
//  MarvelCharacterDetailServiceAPI.swift
//  MarvelComicsTests
//
//  Created by Manish Tamta on 24/05/2022.
//

import XCTest
@testable import MarvelComics

class MarvelCharacterDetailServiceAPI: XCTestCase {
    
    var util: MSUtils!
    var apiService: PerformRequest!
    
    override func setUp() {
        util = MSUtils()
        apiService = APIMarvelService()
    }
    
    //MARK:- Test the get Characters request passing key params.
    func testCharacterListApiResourceWithEmptyStringRturnsError() {
       
        let url = APIMarvelService.URL(.characterComics(id: 1011334))
        let baseURL = util.buildServiceRequestUrl(baseUrl: url)
        XCTAssertNotNil(baseURL?.isEmpty)
    }
    
    
    //MARK:- Test the get Characters requeset
    func testCharacterListApiResourceWithParametersReturnsError() {

        let expectation = self.expectation(description: "testAPICall")
        apiService.performRequest(endPoint: .characterComics(id: 1011334), parameters: [:]) { (result: APIResult<ComicsDataModel, APIError>) in
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
        apiService.performRequest(endPoint: .characterComics(id: 1011334), parameters: [:]) { (result: APIResult<ComicsDataModel, APIError>) in
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
