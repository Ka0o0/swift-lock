//
//  LocalSecurityError.swift
//  SwiftLock
//
//  Created by Kai Takac on 14.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation

public enum LocalSecurityError: Error {
    case appLocked
    case invalidPasscode
    case noPasscodeProvided
    case storageFailure
    case passcodeMismatch
    case unknown
    case touchIdNotInitialised
    case touchIdNotAvailable
}
