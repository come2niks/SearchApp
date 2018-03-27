//
//  SearchAppTests.swift
//  SearchAppTests
//
//  Created by Nikhilesh Walde on 21/03/2018.
//  Copyright © 2018 PrepayNation. All rights reserved.
//

import XCTest
@testable import SearchApp

class SearchAppTests: XCTestCase {
    /// System under test for Network Manager
    var sut: NetworkManager?

    override func setUp() {
        super.setUp()
        sut = NetworkManager()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testFetchMoviesList() {
        // Given A NetworkManager
        let sut = self.sut!
        
        // When fetch movies list
        let expect = XCTestExpectation(description: "callback")
        
        // Call fetchMoviesList with sample string and default page number
        sut.fetchMoviesList(fromSearch: "Batman", pageNumber: 1) { (moviesList) in
            expect.fulfill()
            XCTAssertEqual(moviesList?.count, 20)
            for movie in moviesList! {
                XCTAssertNotNil(movie.title)
            }
        }
        wait(for: [expect], timeout: 3.1)
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
