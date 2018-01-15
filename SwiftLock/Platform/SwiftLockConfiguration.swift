//
//  SwiftLockConfiguration.swift
//  SwiftLock
//
//  Created by Kai Takac on 13.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation

public struct SwiftLockConfiguration {

    let generatedKeyLengthInBytes: Int
    let keychainServiceId: String
    let userDefault: UserDefaults

    public init(
        generatedKeyLengthInBytes: Int,
        keychainServiceId: String,
        userDefault: UserDefaults = UserDefaults.standard
    ) {
        self.generatedKeyLengthInBytes = generatedKeyLengthInBytes
        self.keychainServiceId = keychainServiceId
        self.userDefault = userDefault
    }
}
