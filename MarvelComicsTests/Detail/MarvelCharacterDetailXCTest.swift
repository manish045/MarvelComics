//
//  MarvelCharacterDetailXCTest.swift
//  MarvelComicsTests
//
//  Created by Manish Tamta on 24/05/2022.
//

import XCTest
@testable import MarvelComics

class MarvelCharacterDetailXCTest: XCTestCase {
    
    //MARK:- Test the datasource before request comics from server
    func testValueInDataSourceWhenLoadingComicsFromServer() throws {
        
        let sut = try makeSUT()
        let collectionView = sut.collectionView
        // expected one section
        XCTAssertEqual(collectionView?.numberOfSections, 2, "Expected one section in collection view")
        
        // expected zero cells
        XCTAssertEqual(collectionView?.numberOfItems(inSection: MCharacterDetailSection.characterImageAndDescription.rawValue), 1)
        
        // expected one cells
        XCTAssertEqual(collectionView?.numberOfItems(inSection: MCharacterDetailSection.comicsForCharater.rawValue), 0)
    }
    
    //MARK:- Test the datasource after successful request from server with Zero Comics
    func testEmptyValueInDataSourceWhenFinishLoadingWithZerorResultFromServer() throws {

        let sut = try makeSUT()
        let collectionView = sut.collectionView

        sut.createSnapshot(marvelCharacter: sut.viewModel.marvelCharacterModel, comicsForCharacter: [])
        // expected one section
        XCTAssertEqual(collectionView?.numberOfSections, 2, "Expected one section in collection view")

        // expected one cells
        XCTAssertEqual(collectionView?.numberOfItems(inSection: MCharacterDetailSection.characterImageAndDescription.rawValue), 1)
        
        XCTAssertEqual(collectionView?.numberOfItems(inSection: MCharacterDetailSection.comicsForCharater.rawValue), 0)
    }

    //MARK:- Test the datasource after failed request from server with Zero Comics
    func testEmptyValueInDataSourceWhenFailedLoadingWithZerorResultFromServer() throws {

        let sut = try makeSUT()
        let collectionView = sut.collectionView

        sut.createSnapshot(marvelCharacter: sut.viewModel.marvelCharacterModel, comicsForCharacter: [])
        // expected one section
        XCTAssertEqual(collectionView?.numberOfSections, 2, "Expected one section in collection view")

        // expected one cells
        XCTAssertEqual(collectionView?.numberOfItems(inSection: MCharacterDetailSection.characterImageAndDescription.rawValue), 1)
        
        XCTAssertEqual(collectionView?.numberOfItems(inSection: MCharacterDetailSection.comicsForCharater.rawValue), 0)
    }

    //MARK:- Test the datasource after loading request from server with some Comics
    func testSomeValueInDataSourceWhenLoadingMoreDataFromServer() throws {

        let sut = try makeSUT()
        let collectionView = sut.collectionView
        // expected one section
        
        let comicModel = ComicsModel(id: 1111,
                                     title: "Best Comic",
                                     issueNumber: 123456,
                                     thumbnail: nil)

        sut.createSnapshot(marvelCharacter: sut.viewModel.marvelCharacterModel, comicsForCharacter: [comicModel])
        // expected one section
        XCTAssertEqual(collectionView?.numberOfSections, 2, "Expected one section in collection view")

        // expected one cells
        XCTAssertEqual(collectionView?.numberOfItems(inSection: MCharacterDetailSection.characterImageAndDescription.rawValue), 1)
        
        XCTAssertEqual(collectionView?.numberOfItems(inSection: MCharacterDetailSection.comicsForCharater.rawValue), 1)
    }
    
    private func makeSUT() throws -> MCharacterDetailViewController  {
        let coordinator = MCharacterDetailCoordinator()
        
        let mockData = MarvelCharacterModel(id: 1234, name: "Test Hero", resultDescription: "Just mocking hero to check data", thumbnail: nil)
        
        let sut = try XCTUnwrap(coordinator.makeModule(model: mockData) as? MCharacterDetailViewController)
        let viewModel = DefaultMCharacterDetailViewModel(marvelCharacterModel: mockData)
        sut.viewModel = viewModel
        _ = sut.view
        return sut
    }

}
