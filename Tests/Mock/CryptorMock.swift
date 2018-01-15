//
//  CryptorMock.swift
//  SwiftLock
//
//  Created by Kai Takac on 14.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation
@testable import SwiftLock

final class CryptorMock: Cryptor {

    static let keyDataSeparator = "---"

    func encrypt(using key: String, data: Data) throws -> Data {
        let cipherText = String(format: "%@%@%@", key, CryptorMock.keyDataSeparator, data.base64EncodedString())
        guard let data = cipherText.data(using: .utf8) else {
            throw CryptoError.encryptionFailed
        }

        return data

    }

    func decrypt(using key: String, data: Data) throws -> Data {
        guard let stringData = String(data: data, encoding: .utf8) else {
            throw CryptoError.decryptionFailed
        }

        let splitStringData = stringData.components(separatedBy: CryptorMock.keyDataSeparator)
        guard splitStringData.count == 2,
            splitStringData[0] == key,
            let result = Data(base64Encoded: splitStringData[1]) else {
            throw CryptoError.decryptionFailed
        }

        return result
    }
}
