//
//  BiometricSecurityService.swift
//  SwiftLock
//
//  Created by Kai Takac on 14.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift
import LocalAuthentication

final class BiometricSecurityService {

    var isBiometricReaderAvailable: Bool {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            if #available(iOS 11.2, *) {
                return context.biometryType != .none
            } else {
                return context.biometryType != LABiometryType.LABiometryNone
            }
        }

        if let error = error {
            print("Failed to access biometrics: \(String(describing: error))")
        }

        return false
    }

    let isUserEnrolledInBiometricAuthentication: Observable<Bool>
    private(set) var isUserCurrentlyEnrolledInBiometricAuthentication: Bool

    private let userDefaultsEnrollmentStatusKey = "user_enrolled"
    private let keychainDecryptionKeyKey = "biometric_key"

    private let securityService: SecurityService
    private let biometricKeychain: BiometricKeychain
    private let userDefaults: UserDefaults
    private let isUserEnrolledInBiometricAuthenticationSubject: BehaviorSubject<Bool>

    init(
        securityService: SecurityService,
        biometricKeychain: BiometricKeychain,
        userDefaults: UserDefaults
    ) {
        self.securityService = securityService
        self.biometricKeychain = biometricKeychain
        self.userDefaults = userDefaults

        let isEnrolled = userDefaults.bool(forKey: userDefaultsEnrollmentStatusKey)
        isUserEnrolledInBiometricAuthenticationSubject = BehaviorSubject(
            value: isEnrolled
        )
        isUserEnrolledInBiometricAuthentication = isUserEnrolledInBiometricAuthenticationSubject.asObserver()
        isUserCurrentlyEnrolledInBiometricAuthentication = isEnrolled
    }

    func unlockAppUsingBiometric(with explanation: String) -> Single<Void> {
        return biometricKeychain.get(keychainDecryptionKeyKey, explanation: explanation)
            .flatMap { storedValue -> Single<Void> in
                if let decryptionKeyBase64 = storedValue,
                    let decryptionKey = Data(base64Encoded: decryptionKeyBase64) {
                    return self.securityService.unlockAppUsing(decryptionKey: decryptionKey)
                } else {
                    return Single.error(LocalSecurityError.touchIdNotInitialised)
                }
            }
    }

    func removeUserFromBiometricAuthentication() -> Single<Void> {
        return biometricKeychain.remove(key: keychainDecryptionKeyKey)
            .do(onNext: {
                self.userDefaults.set(false, forKey: self.userDefaultsEnrollmentStatusKey)
                self.isUserCurrentlyEnrolledInBiometricAuthentication = false
            })
    }

    func enrollUserInBiometricAuthentication(explanation: String) -> Single<Void> {
        guard let decryptionKey = securityService.decryptionKey else {
            return Single.error(LocalSecurityError.appLocked)
        }

        return biometricKeychain.set(
            decryptionKey.base64EncodedString(),
            key: keychainDecryptionKeyKey,
            explanation: explanation
        )
        .do(onNext: {
            self.userDefaults.set(true, forKey: self.userDefaultsEnrollmentStatusKey)
            self.isUserCurrentlyEnrolledInBiometricAuthentication = true
        })
        .catchError { _ in
            Single.error(LocalSecurityError.touchIdNotAvailable)
        }
    }
}
