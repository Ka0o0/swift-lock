//
//  DefaultSwiftLock.swift
//  SwiftLock
//
//  Created by Kai Takac on 13.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation
import KeychainAccess

public final class DefaultSwiftLock: SwiftLock {

    private let securityService: SecurityService
    private let biometricSecurityService: BiometricSecurityService

    public init(configuration: SwiftLockConfiguration) {
        let randomDataGenerator = CommonCryptoSecureRandomDataGenerator()
        let ivProvider = UserDefaultsIVProvider(
            userDefaults: configuration.userDefault,
            randomDataGenerator: randomDataGenerator
        )
        let hashService = CommonCryptoHashService()
        let cryptor = AESCryptor(hashService: hashService, ivProvider: ivProvider)
        let keychainAccess = KeychainAccess.Keychain(service: configuration.keychainServiceId)
        let keychain = KeychainAccessKeychain(keychainAccess: keychainAccess)

        securityService = SecurityService(
            keyLength: configuration.generatedKeyLengthInBytes,
            cryptor: cryptor,
            keychain: keychain,
            randomDataGenerator: randomDataGenerator
        )
        biometricSecurityService = BiometricSecurityService(
            securityService: securityService,
            biometricKeychain: KeychainAccessBiometricKeychain(keychainAccess: keychainAccess),
            userDefaults: configuration.userDefault
        )
    }

    public func makeAppDecryptionKeyUseCase() -> AppDecryptionKeyUseCase {
        return DefaultAppDecryptionKeyUseCase(securityService: securityService)
    }

    public func makeAppLockStatusUseCase() -> AppLockStatusUseCase {
        return DefaultAppLockStatusUseCase(securityService: securityService)
    }

    public func makeClearAppLockPasscodeUseCase() -> ClearAppLockPasscodeUseCase {
        return DefaultClearAppLockPasscodeUseCase(
            securityService: securityService,
            biometricSecurityService: biometricSecurityService
        )
    }

    public func makeLockAppUseCase() -> LockAppUseCase {
        return DefaultLockAppUseCase(securityService: securityService)
    }

    public func makeSetAppLockPasscodeUseCase() -> SetAppLockPasscodeUseCase {
        return DefaultSetAppLockPasscodeUseCase(securityService: securityService)
    }

    public func makeUnlockAppUseCase() -> UnlockAppUseCase {
        return DefaultUnlockAppUseCase(securityService: securityService)
    }

    public func makeBiometricAuthenticationEnrollmentUseCase() -> BiometricAuthenticationEnrollmentUseCase {
        return DefaultBiometricAuthenticationEnrollmentUseCase(biometricSecurityService: biometricSecurityService)
    }

    public func makeBiometricAppUnlockUseCase() -> BiometricAppUnlockUseCase {
        return DefaultBiometricAppUnlockUseCase(biometricSecurityService: biometricSecurityService)
    }

    public func makeBiometricAuthenticationDisablingUseCase() -> BiometricAuthenticationDisablingUseCase {
        return DefaultBiometricAuthenticationDisablingUseCase(biometricSecurityService: biometricSecurityService)
    }

    public func makeBiometricAuthenticationStatusUseCase() -> BiometricAuthenticationStatusUseCase {
        return DefaultBiometricAuthenticationStatusUseCase(biometricSecurityService: biometricSecurityService)
    }
}
