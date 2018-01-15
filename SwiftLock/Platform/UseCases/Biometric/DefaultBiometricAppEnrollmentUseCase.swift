//
//  DefaultBiometricAppEnrollmentUseCase.swift
//  SwiftLock
//
//  Created by Kai Takac on 14.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

final class DefaultBiometricAuthenticationEnrollmentUseCase: BiometricAuthenticationEnrollmentUseCase {

    private let biometricSecurityService: BiometricSecurityService

    init(biometricSecurityService: BiometricSecurityService) {
        self.biometricSecurityService = biometricSecurityService
    }

    func enrollUserInBiometricAuthentication(explanation: String) -> Single<Void> {
        return biometricSecurityService.enrollUserInBiometricAuthentication(explanation: explanation)
    }
}
