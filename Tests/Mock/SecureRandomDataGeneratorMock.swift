//
//  SecureRandomDataGeneratorMock.swift
//  SwiftLockTests
//
//  Created by Kai Takac on 14.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation
@testable import SwiftLock

final class SecureRandomDataGeneratorMock: SecureRandomDataGenerator {

    func generateRandomData(of sizeInBytes: Int) -> Data {
        return "random".data(using: .utf8) ?? Data()
    }
}
