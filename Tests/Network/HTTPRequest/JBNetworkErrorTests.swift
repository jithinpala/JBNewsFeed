//
//  JBNetworkErrorTests.swift
//  JBNewsFeedTests
//
//  Created by Jithin Balan on 31/8/21.
//

@testable import JBNewsFeed
import XCTest
import Nimble

class JBNetworkErrorTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testJBNetworkError_ShouldReturnNetworkTimeout() {
        let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut, userInfo: nil)
        var correctError = false
        switch JBNetworkError(error) {
        case .networkTimeout:
            correctError = true
        default:
            fail("JBNetworkError failed unexpected error")
        }
        expect(correctError).to(beTrue())
    }
    
    func testJBNetworkError_ShouldReturnNotConnectedToInternet() {
        let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        var correctError = false
        switch JBNetworkError(error) {
        case .notConnectedToInternet:
            correctError = true
        default:
            fail("JBNetworkError failed unexpected error")
        }
        expect(correctError).to(beTrue())
    }
    
    func testJBNetworkError_ShouldReturnRequestCancelled() {
        let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorCancelled, userInfo: nil)
        var correctError = false
        switch JBNetworkError(error) {
        case .requestCancelled:
            correctError = true
        default:
            fail("JBNetworkError failed unexpected error")
        }
        expect(correctError).to(beTrue())
    }

}
