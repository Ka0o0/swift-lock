//
//  DefaultLockAppUseCase.swift
//  SwiftLock
//
//  Created by Kai Takac on 14.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation

final class DefaultLockAppUseCase: LockAppUseCase {

    private let securityService: SecurityService

    init(securityService: SecurityService) {
        self.securityService = securityService
    }

    func lockApp() {
        securityService.lock()
    }
}
