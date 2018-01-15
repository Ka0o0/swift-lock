//
//  CryptoError.swift
//  SwiftLock
//
//  Created by Kai Takac on 13.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation

enum CryptoError: Error {
    case failedToCreateHash
    case invalidKey
    case encryptionFailed
    case decryptionFailed
    case failedToGenerateRandomData
    case failedToCreateIV
}
