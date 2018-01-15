//
//  IVProvider.swift
//  SwiftLock
//
//  Created by Kai Takac on 13.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation
import Security

protocol IVProvider {
    func getInitialisationVector(of sizeInBytes: Int) throws -> [UInt8]
}

final class UserDefaultsIVProvider: IVProvider {

    private let userDefaults: UserDefaults
    private let randomDataGenerator: SecureRandomDataGenerator

    init(
        userDefaults: UserDefaults,
        randomDataGenerator: SecureRandomDataGenerator
    ) {
        self.userDefaults = userDefaults
        self.randomDataGenerator = randomDataGenerator
    }

    func getInitialisationVector(of sizeInBytes: Int) throws -> [UInt8] {
        let userDefaultsKey = makeKey(for: sizeInBytes)

        var iv: String! = userDefaults.string(forKey: userDefaultsKey)
        if iv == nil {
            iv = try randomDataGenerator.generateRandomData(of: sizeInBytes).base64EncodedString()
            userDefaults.set(iv, forKey: userDefaultsKey)
        }

        guard let data = Data(base64Encoded: iv) else {
            throw CryptoError.failedToCreateIV
        }

        return [UInt8](data)
    }
}

private extension UserDefaultsIVProvider {

    func makeKey(for size: Int) -> String {
        return String(format: "iv_%d", size)
    }
}
