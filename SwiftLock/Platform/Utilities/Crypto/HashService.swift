//
//  HashService.swift
//  SwiftLock
//
//  Created by Kai Takac on 13.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation
import IDZSwiftCommonCrypto

protocol HashService {

    func sha512(string: String) throws -> String
}

final class CommonCryptoHashService: HashService {

    func sha512(string: String) throws -> String {
        let sha512 = Digest(algorithm: .sha512)

        guard let result = sha512.update(string: string)?.final() else {
            throw CryptoError.failedToCreateHash
        }

        return hexString(fromArray: result)
    }
}
