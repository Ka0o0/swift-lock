//
//  DefaultBiometricAuthenticationStatusUseCase.swift
//  SwiftLock
//
//  Created by Kai Takac on 14.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

final class DefaultBiometricAuthenticationStatusUseCase: BiometricAuthenticationStatusUseCase {

    var isBiometricReaderAvailable: Bool {
        return biometricSecurityService.isBiometricReaderAvailable
    }

    var isUserEnrolledInBiometricAuthentication: Observable<Bool> {
        return biometricSecurityService.isUserEnrolledInBiometricAuthentication
    }

    var isUserCurrentlyEnrolledInBiometricAuthentication: Bool {
        return biometricSecurityService.isUserCurrentlyEnrolledInBiometricAuthentication
    }

    private let biometricSecurityService: BiometricSecurityService

    init(biometricSecurityService: BiometricSecurityService) {
        self.biometricSecurityService = biometricSecurityService
    }
}
