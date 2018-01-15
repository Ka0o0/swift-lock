//
//  SecureRandomDataGenerator.swift
//  SwiftLock
//
//  Created by Kai Takac on 13.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation
import Security

protocol SecureRandomDataGenerator {
    func generateRandomData(of sizeInBytes: Int) throws -> Data
}

final class CommonCryptoSecureRandomDataGenerator: SecureRandomDataGenerator {

    func generateRandomData(of sizeInBytes: Int) throws -> Data {
        guard sizeInBytes > 0 else {
            return Data()
        }

        var data = Data(count: sizeInBytes)
        let resultCode = data.withUnsafeMutableBytes { mutableBytes in
            SecRandomCopyBytes(kSecRandomDefault, data.count, mutableBytes)
        }
        guard resultCode == 0 else {
            throw CryptoError.failedToGenerateRandomData
        }

        return data
    }
}
