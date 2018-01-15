//
//  SwiftLock.swift
//  SwiftLock
//
//  Created by Kai Takac on 14.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation

public protocol SwiftLock {

    // MARK: Core
    func makeAppDecryptionKeyUseCase() -> AppDecryptionKeyUseCase
    func makeAppLockStatusUseCase() -> AppLockStatusUseCase
    func makeClearAppLockPasscodeUseCase() -> ClearAppLockPasscodeUseCase
    func makeLockAppUseCase() -> LockAppUseCase
    func makeSetAppLockPasscodeUseCase() -> SetAppLockPasscodeUseCase
    func makeUnlockAppUseCase() -> UnlockAppUseCase

    // MARK: Biometric Unlock
    func makeBiometricAuthenticationEnrollmentUseCase() -> BiometricAuthenticationEnrollmentUseCase
    func makeBiometricAppUnlockUseCase() -> BiometricAppUnlockUseCase
    func makeBiometricAuthenticationDisablingUseCase() -> BiometricAuthenticationDisablingUseCase
    func makeBiometricAuthenticationStatusUseCase() -> BiometricAuthenticationStatusUseCase
}
