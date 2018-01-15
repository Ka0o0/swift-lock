//
//  AESCryptorTests.swift
//  SwiftLockTests
//
//  Created by Kai Takac on 13.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import XCTest
@testable import SwiftLock

final class AESCryptorTests: XCTestCase {

    let testClearTextData: Data! = "Hello World!".data(using: .utf8)
    let testCipherTextData: Data! = Data(base64Encoded: "dbF/O0j1CuGSHE0h")
    var sut: AESCryptor!

    override func setUp() {

        sut = AESCryptor(
            hashService: CommonCryptoHashService(),
            ivProvider: IVProviderMock(initialisationVector: arrayFrom(hexString: "a94a8fe5ccb19ba61c4c0873d391e987"))
        )
    }

    func test_Encrypt_ReturnsFalseForEmptyKey() {
        do {
            _ = try sut.encrypt(using: "", data: testClearTextData)
            XCTFail("Encryption should fail")
        } catch let error {
            XCTAssert(error is CryptoError)
        }
    }

    func test_Encrypt_ReturnsProperData() {
        do {
            let result = try sut.encrypt(using: "test", data: testClearTextData)
            XCTAssertEqual(result.base64EncodedString(), testCipherTextData.base64EncodedString())
        } catch let error {
            XCTFail(String(describing: error))
        }
    }

    func test_Decrypt_ReturnsFalseForEmptyKey() {
        do {
            _ = try sut.decrypt(using: "", data: testCipherTextData)
            XCTFail("Encryption should fail")
        } catch let error {
            XCTAssert(error is CryptoError)
        }
    }

    func test_Decrypt_ReturnsProperData() {
        do {
            let result = try sut.decrypt(using: "test", data: testCipherTextData)
            XCTAssertEqual(result.base64EncodedString(), testClearTextData.base64EncodedString())
        } catch let error {
            XCTFail(String(describing: error))
        }
    }

    func test_EncryptThenDecrypt() {
        do {
            let encrypedData = try sut.encrypt(using: "test", data: testClearTextData)
            let decryptedData = try sut.decrypt(using: "test", data: encrypedData)

            guard let decryptedPlaintext = String(data: decryptedData, encoding: .utf8) else {
                XCTFail("Could not create plaintext")
                return
            }

            XCTAssertEqual(decryptedPlaintext, "Hello World!")
        } catch let error {
            XCTFail(String(describing: error))
        }
    }
}

private extension AESCryptorTests {

    class IVProviderMock: IVProvider {

        private let initialisationVector: [UInt8]

        init(initialisationVector: [UInt8]) {
            self.initialisationVector = initialisationVector
        }

        func getInitialisationVector(of sizeInBytes: Int) throws -> [UInt8] {
            return initialisationVector
        }
    }
}
