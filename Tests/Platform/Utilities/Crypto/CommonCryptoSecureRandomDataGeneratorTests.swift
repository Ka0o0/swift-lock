//
//  CommonCryptoSecureRandomDataGeneratorTests.swift
//  SwiftLockTests
//
//  Created by Kai Takac on 13.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import XCTest
@testable import SwiftLock

class CommonCryptoSecureRandomDataGeneratorTests: XCTestCase {

    func test_GenerateRandomData_ReturnsDataOfSize() {
        let sut = CommonCryptoSecureRandomDataGenerator()
        do {
            let result = try sut.generateRandomData(of: 1)
            XCTAssertEqual(result.count, 1)
        } catch let error {
            XCTFail(error)
        }
    }

}
