//
//  DefaultClearAppLockPasscodeUseCase.swift
//  SwiftLock
//
//  Created by Kai Takac on 14.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

final class DefaultClearAppLockPasscodeUseCase: ClearAppLockPasscodeUseCase {

    private let securityService: SecurityService
    private let biometricSecurityService: BiometricSecurityService

    init(securityService: SecurityService, biometricSecurityService: BiometricSecurityService) {
        self.securityService = securityService
        self.biometricSecurityService = biometricSecurityService
    }

    func clearAppLockPasscode() -> Single<Void> {
        return biometricSecurityService.removeUserFromBiometricAuthentication()
            .flatMap {
                self.securityService.clearAppLockPasscode()
            }
    }
}
