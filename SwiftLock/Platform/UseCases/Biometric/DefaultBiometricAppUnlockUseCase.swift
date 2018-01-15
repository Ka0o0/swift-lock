//
//  DefaultBiometricAppUnlockUseCase.swift
//  SwiftLock
//
//  Created by Kai Takac on 14.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

final class DefaultBiometricAppUnlockUseCase: BiometricAppUnlockUseCase {

    private let biometricSecurityService: BiometricSecurityService

    init(biometricSecurityService: BiometricSecurityService) {
        self.biometricSecurityService = biometricSecurityService
    }

    func unlockAppUsingBiometrics(explanation: String) -> Single<Void> {
        return biometricSecurityService.unlockAppUsingBiometric(with: explanation)
    }
}
