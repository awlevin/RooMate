//
//  RMBBPostTests.swift
//  roomate
//
//  Created by Ritvik Upadhyaya on 23/11/16.
//  Copyright © 2016 RooMate. All rights reserved.
//

import XCTest

class RMBBPostTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        RMBulletinPost.getBulletinPosts(0, lastid: 100000, groupId: 1) { (bbPosts) in
            XCTAssertNotNil(bbPosts)
        }
    }
    
}
