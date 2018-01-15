//
//  UserDefaultsIVProviderTests.swift
//  SwiftLockTests
//
//  Created by Kai Takac on 13.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation
import XCTest
@testable import SwiftLock

class UserDefaultsIVProviderTests: XCTestCase {

    private var userDefaults: UserDefaults!
    private var sut: UserDefaultsIVProvider!
    private var expectedResult: Data! = "iv".data(using: .utf8)

    override func setUp() {
        super.setUp()

        userDefaults = UserDefaults(suiteName: "test")
        sut = UserDefaultsIVProvider(
            userDefaults: userDefaults,
            randomDataGenerator: SecureRandomDataGeneratorMock(value: "iv")
        )
    }

    override func tearDown() {
        super.tearDown()

        userDefaults.removeObject(forKey: "iv_10")
        userDefaults.removeObject(forKey: "iv_1")
    }

    func test_GetIV_ReturnsNewIV() {
        do {
            let result = try sut.getInitialisationVector(of: 10)
            XCTAssertEqual(result, [UInt8](expectedResult))
            XCTAssertEqual(userDefaults.string(forKey: "iv_10"), expectedResult.base64EncodedString())
        } catch let error {
            XCTFail(error)
        }
    }

    func test_GetIV_ReturnsOldIV() {
        do {
            userDefaults.set(expectedResult.base64EncodedString(), forKey: "iv_1")
            let result = try sut.getInitialisationVector(of: 1)
            XCTAssertEqual(result, [UInt8](expectedResult))
        } catch let error {
            XCTFail(error)
        }
    }
}

private extension UserDefaultsIVProviderTests {

    class SecureRandomDataGeneratorMock: SecureRandomDataGenerator {

        private let value: String

        init(value: String) {
            self.value = value
        }

        func generateRandomData(of sizeInBytes: Int) throws -> Data {
            return value.data(using: .utf8) ?? Data()
        }
    }
}
