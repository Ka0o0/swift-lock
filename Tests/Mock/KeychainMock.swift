//
//  KeychainMock.swift
//  SwiftLockTests
//
//  Created by Kai Takac on 14.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation
@testable import SwiftLock

class KeychainMock: Keychain {

    private var values = [String: String]()

    func set(_ value: String, key: String) {
        values[key] = value
    }

    func get(_ key: String) -> String? {
        return values[key]
    }

    func remove(_ key: String) {
        values.removeValue(forKey: key)
    }
}
