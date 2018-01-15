//
//  SecurityServiceTests.swift
//  SwiftLockTests
//
//  Created by Kai Takac on 14.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
@testable import SwiftLock

class SecurityServiceTests: XCTestCase {

    private var sut: SecurityService!
    private var keychain: KeychainMock!
    private var hashServiceMock: HashServiceMock!
    private var cryptor: CryptorMock!
    private var rand: SecureRandomDataGeneratorMock!

    override func setUp() {
        super.setUp()

        keychain = KeychainMock()
        hashServiceMock = HashServiceMock()
        cryptor = CryptorMock()
        rand = SecureRandomDataGeneratorMock()

        sut = SecurityService(
            keyLength: 1,
            cryptor: cryptor,
            keychain: keychain,
            randomDataGenerator: rand
        )
    }

    func test_IsLocked_TrueIfLockKeySet() {
        keychain.set("test_1234_sha256", key: "app_passcode")

        // Create a new instance because keychain will be read upon creation
        let sut = SecurityService(
            keyLength: 1,
            cryptor: cryptor,
            keychain: keychain,
            randomDataGenerator: rand
        )

        guard let result = try? sut.isLocked.debug().toBlocking(timeout: 3).first(),
            let isSet = result
        else {
            XCTFail("Did not emit")
            return
        }
        XCTAssertTrue(isSet)
    }

    func test_IsLocked_FalseIfNoLockKeySet() {
        // Create a new instance because keychain will be read upon creation
        let sut = SecurityService(
            keyLength: 1,
            cryptor: cryptor,
            keychain: keychain,
            randomDataGenerator: rand
        )

        guard let result = try? sut.isLocked.debug().toBlocking(timeout: 3).first(),
            let isSet = result
        else {
            XCTFail("Did not emit")
            return
        }
        XCTAssertFalse(isSet)
    }

    // MARK: UNLOCK USING PASSCODE

    func test_Unlock_ReturnsTrueIfUnlocked() {
        do {
            try sut.unlockAppUsing(passcode: "test").toBlocking().first()
        } catch let error {
            XCTFail(String(describing: error))
        }
    }

    func test_Unlock_ReturnsFalseForEmptyPassword() {
        do {
            keychain.set("test", key: "app_passcode")

            // Create a new instance because keychain will be read upon creation
            let sut = SecurityService(
                keyLength: 1,
                cryptor: cryptor,
                keychain: keychain,
                randomDataGenerator: rand
            )

            try sut.unlockAppUsing(passcode: "").toBlocking().first()

            XCTFail("Should fail")
        } catch let error {
            guard let localSecurityError = error as? LocalSecurityError else {
                XCTFail("Invalid error type")
                return
            }
            XCTAssertEqual(localSecurityError, LocalSecurityError.invalidPasscode)
        }

    }

    func test_Unlock_ReturnsTrueForCorrectPassword() {
        do {
            let passcode = "test"
            let expectedEncryptionResult = makeExpectedEncryptionResult(for: passcode)

            keychain.set(expectedEncryptionResult.base64EncodedString(), key: "app_passcode")

            // Create a new instance because keychain will be read upon creation
            let sut = SecurityService(
                keyLength: 1,
                cryptor: cryptor,
                keychain: keychain,
                randomDataGenerator: rand
            )

            try sut.unlockAppUsing(passcode: passcode).toBlocking(timeout: 3).first()
            guard let decryptionKey = try sut.decryptionKeyObservable.toBlocking(timeout: 3).first() else {
                XCTFail("No decryption key")
                return
            }

            XCTAssertEqual(decryptionKey, rand.generateRandomData(of: 0))
        } catch let error {
            XCTFail(String(describing: error))
        }
    }

    func test_Unlock_ReturnsFalseForIncorrectPassword() {
        do {
            keychain.set("da411138790fa3122b6d9d3257e783ba", key: "app_passcode")

            // Create a new instance because keychain will be read upon creation
            let sut = SecurityService(
                keyLength: 1,
                cryptor: cryptor,
                keychain: keychain,
                randomDataGenerator: rand
            )

            try sut.unlockAppUsing(passcode: "1234").toBlocking().single()
            XCTFail("Should fail")
        } catch let error {
            guard let localSecurityError = error as? LocalSecurityError else {
                XCTFail("Invalid error type")
                return
            }
            XCTAssertEqual(localSecurityError, LocalSecurityError.invalidPasscode)
        }
    }

    // MARK: SET PASSCODE

    func test_SetPasscode_ReturnsFalseIfNotUnlocked() {
        do {
            keychain.set("test_1234_sha256", key: "app_passcode")

            // Create a new instance because keychain will be read upon creation
            let sut = SecurityService(
                keyLength: 1,
                cryptor: cryptor,
                keychain: keychain,
                randomDataGenerator: rand
            )

            try sut.setAppLock(passcode: "test").toBlocking().single()
            XCTFail("Should fail")
        } catch let error {
            guard let localSecurityError = error as? LocalSecurityError else {
                XCTFail("Invalid error type")
                return
            }
            XCTAssertEqual(localSecurityError, LocalSecurityError.appLocked)
        }
    }

    func test_SetPasscode_ReturnsFalseForEmptyPasscode() {
        do {
            try sut.setAppLock(passcode: "").toBlocking().first()
            XCTFail("Should fail")
        } catch let error {
            guard let localSecurityError = error as? LocalSecurityError else {
                XCTFail("Invalid error type")
                return
            }
            XCTAssertEqual(localSecurityError, LocalSecurityError.invalidPasscode)
        }
    }

    func test_SetPasscode_GeneratesNewPasscodeIfNotDoneBefore() {
        do {
            let passcode = "test"

            try sut.setAppLock(passcode: passcode).toBlocking().single()

            let expectedEncryptionResult = makeExpectedEncryptionResult(for: passcode)
            let storedPasscode = keychain.get("app_passcode")
            XCTAssertEqual(storedPasscode, expectedEncryptionResult.base64EncodedString())
        } catch let error {
            XCTFail(String(describing: error))
        }
    }

    func test_SetPasscode_RencryptsOldDecryptionKey() {
        do {
            guard let fakeDecryptionKey = "oldDecryptionKey".data(using: .utf8) else {
                XCTFail("couldn't create data")
                return
            }

            let oldKey = makeExpectedEncryptionResult(for: "asdf", data: fakeDecryptionKey).base64EncodedString()
            keychain.set(oldKey, key: "app_passcode")

            // Create a new instance because keychain will be read upon creation
            let sut = SecurityService(
                keyLength: 1,
                cryptor: cryptor,
                keychain: keychain,
                randomDataGenerator: rand
            )

            try sut.unlockAppUsing(passcode: "asdf").toBlocking().single()
            try sut.setAppLock(passcode: "test").toBlocking().single()

            let expectedEncryptionResult = makeExpectedEncryptionResult(for: "test", data: fakeDecryptionKey)
            let storedPasscode = keychain.get("app_passcode")
            XCTAssertEqual(storedPasscode, expectedEncryptionResult.base64EncodedString())
        } catch let error {
            XCTFail(String(describing: error))
        }
    }
}

private extension SecurityServiceTests {
    func makeExpectedEncryptionResult(for passcode: String, data: Data? = nil) -> Data {
        let string = String(format: "%@---%@", passcode, (data ?? rand.generateRandomData(of: 0)).base64EncodedString())
        guard let data = string.data(using: .utf8) else {
            XCTFail("Couldn't create data")
            return Data()
        }
        return data
    }
}
