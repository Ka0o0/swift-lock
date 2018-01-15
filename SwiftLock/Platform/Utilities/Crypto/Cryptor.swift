//
//  Cryptor.swift
//  SwiftLock
//
//  Created by Kai Takac on 13.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation
import IDZSwiftCommonCrypto

protocol Cryptor {

    func encrypt(using key: String, data: Data) throws -> Data
    func decrypt(using key: String, data: Data) throws -> Data
}

final class AESCryptor: Cryptor {

    private let hashService: HashService
    private let ivProvider: IVProvider

    init(hashService: HashService, ivProvider: IVProvider) {
        self.hashService = hashService
        self.ivProvider = ivProvider
    }

    func encrypt(using key: String, data: Data) throws -> Data {
        let aesParameters = try extract256BitKeyAnd128BitIvFrom(key: key)

        let cryptor = IDZSwiftCommonCrypto.Cryptor(
            operation: .encrypt,
            algorithm: .aes,
            mode: .CFB,
            padding: .PKCS7Padding,
            key: aesParameters.key,
            iv: aesParameters.iv
        )
        guard let result = cryptor.update(data: data)?.final() else {
            throw CryptoError.encryptionFailed
        }

        return Data(bytes: result)
    }

    func decrypt(using key: String, data: Data) throws -> Data {
        let aesParameters = try extract256BitKeyAnd128BitIvFrom(key: key)

        let cryptor = IDZSwiftCommonCrypto.Cryptor(
            operation: .decrypt,
            algorithm: .aes,
            mode: .CFB,
            padding: .PKCS7Padding,
            key: aesParameters.key,
            iv: aesParameters.iv
        )
        guard let result = cryptor.update(data: data)?.final() else {
            throw CryptoError.encryptionFailed
        }

        return Data(bytes: result)
    }
}

private extension AESCryptor {
    func extract256BitKeyAnd128BitIvFrom(key: String) throws -> (key: [UInt8], iv: [UInt8]) {
        guard !key.isEmpty else {
            throw CryptoError.invalidKey
        }

        let hashedPasscode = try hashService.sha512(string: key)
        assert(hashedPasscode.count == 128) // sha512 in hexa = 128 chars

        let data = arrayFrom(hexString: hashedPasscode)
        let key = data[0...31]
        let iv = try ivProvider.getInitialisationVector(of: 16)
        return (key: Array(key), iv: iv)
    }
}
