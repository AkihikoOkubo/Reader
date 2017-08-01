//
//  ReaderTests.swift
//  ReaderTests
//
//  Created by kazuyuki takahashi on 2017/07/28.
//  Copyright © 2017年 kazuyuki takahashi. All rights reserved.
//

import XCTest
@testable import Reader

struct Hoge {
    var a = [String]()
    
    subscript(safe index: Int) -> String? {
        return a.indices.contains(index) ? a[index] : nil
//        return index < a.count ? a[index] : nil
    }
}

class ReaderTests: XCTestCase {
    
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
    }
    
}
