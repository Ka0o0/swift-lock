//
//  DefaultBiometricAuthenticationDisablingUseCase.swift
//  SwiftLock
//
//  Created by Kai Takac on 14.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

final class DefaultBiometricAuthenticationDisablingUseCase: BiometricAuthenticationDisablingUseCase {

    private let biometricSecurityService: BiometricSecurityService

    init(biometricSecurityService: BiometricSecurityService) {
        self.biometricSecurityService = biometricSecurityService
    }

    func disableBiometricAuthentication() -> Single<Void> {
        return biometricSecurityService.removeUserFromBiometricAuthentication()
    }
}
