//
//  BiometricKeychain.swift
//  SwiftLock
//
//  Created by Kai Takac on 14.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation
import KeychainAccess
import RxSwift

protocol BiometricKeychain {
    func set(_ value: String, key: String, explanation: String) -> Single<Void>
    func get(_ key: String, explanation: String) -> Single<String?>
    func remove(key: String) -> Single<Void>
}

final class KeychainAccessBiometricKeychain: BiometricKeychain {

    private let keychainAccess: KeychainAccess.Keychain

    init(keychainAccess: KeychainAccess.Keychain) {
        self.keychainAccess = keychainAccess
    }

    func set(_ value: String, key: String, explanation: String) -> Single<Void> {
        return Single<Void>.create { emitter in
            DispatchQueue.global().async {
                do {
                    try self.setKeychainEntry(value, key: key, explanation: explanation)
                    emitter(.success(()))
                } catch let error {
                    emitter(.error(error))
                }
            }

            return Disposables.create()
        }
    }

    func get(_ key: String, explanation: String) -> Single<String?> {
        return Single.create { emitter in
            DispatchQueue.global().async {
                do {
                    let value = try self.getKeychainEntry(key, explanation: explanation)
                    emitter(.success(value))
                } catch let error {
                    emitter(.error(error))
                }
            }

            return Disposables.create()
        }
    }

    func remove(key: String) -> Single<Void> {
        return Single.create { emitter in
            DispatchQueue.global().async {
                do {
                    try self.keychainAccess.remove(key)
                    emitter(.success(()))
                } catch let error {
                    emitter(.error(error))
                }
            }

            return Disposables.create()
        }
    }
}

private extension KeychainAccessBiometricKeychain {
    func setKeychainEntry(_ value: String, key: String, explanation: String) throws {
        try keychainAccess
            .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .userPresence)
            .authenticationPrompt(explanation)
            .set(value, key: key)
    }

    func getKeychainEntry(_ key: String, explanation: String) throws -> String? {
        return try keychainAccess
            .authenticationPrompt(explanation)
            .get(key)
    }
}
