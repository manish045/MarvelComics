//
//  MarvelCharacterListXCTest.swift
//  MarvelComicsTests
//
//  Created by Manish Tamta on 24/05/2022.
//

import XCTest
import Combine
@testable import MarvelComics

class MarvelCharacterListXCTest: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
    }
    
    //MARK:- Test the datasource before request to server
    func testEmptyValueInDataSourceWhenLoadingDataFromServer() throws {
        
        let sut = try makeSUT()
        let collectionView = sut.collectionView
        // expected one section
        XCTAssertEqual(collectionView?.numberOfSections, 2, "Expected two section in collection view")
        
        // expected zero cells
        XCTAssertEqual(collectionView?.numberOfItems(inSection: MarvelCharacterSection.characters.rawValue), 0)
        
        // expected one cells
        XCTAssertEqual(collectionView?.numberOfItems(inSection: MarvelCharacterSection.loader.rawValue), 1)
    }
    
    //MARK:- Test the datasource after successful request from server with Zero Data
    func testEmptyValueInDataSourceWhenFinishLoadingWithZerorResultFromServer() throws {
        
        let sut = try makeSUT()
        let collectionView = sut.collectionView
        
        sut.createSnapshot(characterList: [], state: .completed)
        // expected one section
        XCTAssertEqual(collectionView?.numberOfSections, 1, "Expected one section in collection view")
        
        // expected zero cells
        XCTAssertEqual(collectionView?.numberOfItems(inSection: MarvelCharacterSection.characters.rawValue), 0)
    }
    
    //MARK:- Test the datasource after failed request from server with Zero Data
    func testEmptyValueInDataSourceWhenFailedLoadingWithZerorResultFromServer() throws {
        
        let sut = try makeSUT()
        let collectionView = sut.collectionView
        
        sut.createSnapshot(characterList: [], state: .failed)
        // expected one section
        XCTAssertEqual(collectionView?.numberOfSections, 1, "Expected one section in collection view")
        
        // expected zero cells
        XCTAssertEqual(collectionView?.numberOfItems(inSection: MarvelCharacterSection.characters.rawValue), 0)
    }
    
    //MARK:- Test the datasource after loading request from server with some Data
    func testSomeValueInDataSourceWhenLoadingMoreDataFromServer() throws {
        
        let sut = try makeSUT()
        let collectionView = sut.collectionView
        // expected one section
        
        let mockData = MarvelCharacterModel(id: 1234, name: "Test Hero", resultDescription: "Just mocking hero to check data", thumbnail: nil)
        
        sut.createSnapshot(characterList: [mockData], state: .loading)
        XCTAssertEqual(collectionView?.numberOfSections, 2, "Expected two section in collection view")
        
        // expected zero cells
        XCTAssertEqual(collectionView?.numberOfItems(inSection: MarvelCharacterSection.characters.rawValue), 1)
        
        // expected one cells
        XCTAssertEqual(collectionView?.numberOfItems(inSection: MarvelCharacterSection.loader.rawValue), 1)
    }
    
    //MARK:- Test the datasource after successful request from server with some Data
    func testEmptyValueInDataSourceWhenFinishLoadingWithSomeResultFromServer() throws {
        
        let sut = try makeSUT()
        let collectionView = sut.collectionView
        
        let mockData = MarvelCharacterModel(id: 1234, name: "Test Hero", resultDescription: "Just mocking hero to check data", thumbnail: nil)
        
        sut.createSnapshot(characterList: [mockData], state: .completed)
        // expected one section
        XCTAssertEqual(collectionView?.numberOfSections, 1, "Expected one section in collection view")
        
        // expected zero cells
        XCTAssertEqual(collectionView?.numberOfItems(inSection: MarvelCharacterSection.characters.rawValue), 1)
    }
    
    func testObservers() throws {
        let sut = try makeSUT()
        
        let viewModel = sut.viewModel!
        
        let expectation = XCTestExpectation(description: "load data")
        let errorExpectation = XCTestExpectation(description: "Error Occured")
        let searchExpectation = XCTestExpectation(description: "search occured")
        
        viewModel.loadDataSource
            .sink (receiveValue: { (_, value) in
                XCTAssertEqual(value.count, 0)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        viewModel.didGetError
            .sink { _ in
                errorExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.searchTextSubject
            .sink (receiveValue: { value in
                XCTAssertNotNil(value)
                searchExpectation.fulfill()
            })
            .store(in: &cancellables)
    }
    
    
    private func makeSUT() throws -> MarvelCharacterListViewController  {
        let coordinator = MarvelCharacterListCoordinator()
        let sut = try XCTUnwrap(coordinator.makeModule() as? MarvelCharacterListViewController)
        let viewModel = DefaultMarvelCharacterListViewModel(coordinator: coordinator)
        sut.viewModel = viewModel
        _ = sut.view
        return sut
    }

}


//let coordinator = MarvelCharacterListCoordinator()
//let initialVC = try XCTUnwrap(coordinator.makeModule() as! MarvelCharacterListViewController)
//coordinator.rootController = initialVC
//return initialVC
