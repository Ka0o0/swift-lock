//
//  HashServiceMock.swift
//  SwiftLock
//
//  Created by Kai Takac on 14.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation
@testable import SwiftLock

class HashServiceMock: HashService {
    // swiftlint:disable line_length
    let fakeHash = "ee26b0dd4af7e749aa1a8ee3c10ae9923f618980772e473f8819a5d4940e0db27ac185f8a0e1d5f84f88bc887fd67b143732c304cc5fa9ad8e6f57f50028a8ff"
    // swiftlint:enable line_length

    func sha512(string: String) throws -> String {
        return fakeHash
    }
}
