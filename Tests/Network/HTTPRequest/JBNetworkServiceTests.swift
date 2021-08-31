//
//  JBNetworkServiceTests.swift
//  JBNewsFeedTests
//
//  Created by Jithin Balan on 31/8/21.
//

@testable import JBNewsFeed
import XCTest
import Nimble

class JBNetworkServiceTests: XCTestCase {

    var networkService: JBNetworkService?
    
    override func setUp() {
        super.setUp()
        networkService = JBNetworkService()
    }
    
    override func tearDown() {
        super.tearDown()
        networkService = nil
    }
    
    func testJBNetworkService_InitializerShouldNotBeNil() {
        expect(self.networkService).notTo(beNil())
    }

}
