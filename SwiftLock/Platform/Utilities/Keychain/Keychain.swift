//
//  Keychain.swift
//  SwiftLock
//
//  Created by Kai Takac on 14.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation
import KeychainAccess
import IDZSwiftCommonCrypto

protocol Keychain {
    func set(_ value: String, key: String) throws
    func get(_ key: String) throws -> String?
    func remove(_ key: String) throws
}

class KeychainAccessKeychain: Keychain {

    let keychainAccess: KeychainAccess.Keychain

    init(keychainAccess: KeychainAccess.Keychain) {
        self.keychainAccess = keychainAccess
    }

    func set(_ value: String, key: String) throws {
        try keychainAccess.set(value, key: key)
    }

    func get(_ key: String) throws -> String? {
        return try keychainAccess.get(key)
    }

    func remove(_ key: String) throws {
        return try keychainAccess.remove(key)
    }
}
