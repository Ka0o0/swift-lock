//
//  CommonCryptoHashServiceTests.swift
//  SwiftLockTests
//
//  Created by Kai Takac on 13.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import XCTest
@testable import SwiftLock

class CommonCryptoHashServiceTests: XCTestCase {

    var sut: HashService!

    override func setUp() {
        super.setUp()

        sut = CommonCryptoHashService()
    }

    func test_Sha512String() {
        do {
            let result = try sut.sha512(string: "test")

            // swiftlint:disable line_length
            XCTAssertEqual(result, "ee26b0dd4af7e749aa1a8ee3c10ae9923f618980772e473f8819a5d4940e0db27ac185f8a0e1d5f84f88bc887fd67b143732c304cc5fa9ad8e6f57f50028a8ff")
            // swiftlint:enable line_length
        } catch let error {
            XCTFail(String(describing: error))
        }
    }
}
