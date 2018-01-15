//
//  SecurityService.swift
//  SwiftLock
//
//  Created by Kai Takac on 14.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

final class SecurityService {

    private let cryptor: Cryptor
    private let keychain: Keychain
    private let randomDataGenerator: SecureRandomDataGenerator
    private let keyLength: Int

    private let keychainPasscodeKey = "app_passcode"
    private let hasLockKeySetSubject = BehaviorSubject(value: true)
    private var hasLockKeySet = false {
        didSet {
            hasLockKeySetSubject.on(.next(hasLockKeySet))
        }
    }

    private let decryptionKeySubject = BehaviorSubject<Data?>(value: nil)
    private(set) var decryptionKey: Data? {
        didSet {
            decryptionKeySubject.on(.next(decryptionKey))
        }
    }
    var decryptionKeyObservable: Observable<Data?> {
        return decryptionKeySubject.asObserver()
    }

    var isLocked: Observable<Bool> {
        let decryptionKeyObservableSet = decryptionKeySubject.asObservable().map { $0 != nil }
        let hasLockKeyObservable = hasLockKeySetSubject.asObservable()
        return Observable.combineLatest(hasLockKeyObservable, decryptionKeyObservableSet) {
            $0 && !$1
        }
    }

    init(keyLength: Int, cryptor: Cryptor, keychain: Keychain, randomDataGenerator: SecureRandomDataGenerator) {
        self.keyLength = keyLength
        self.cryptor = cryptor
        self.keychain = keychain
        self.randomDataGenerator = randomDataGenerator

        do {
            let encryptionKey = try keychain.get(keychainPasscodeKey)
            hasLockKeySet = encryptionKey != nil
            hasLockKeySetSubject.on(.next(hasLockKeySet))
        } catch {}
    }

    func lock() {
        decryptionKey = nil
    }

    func setAppLock(passcode: String) -> Single<Void> {
        if checkLocked() {
            return Single.error(LocalSecurityError.appLocked)
        } else if passcode.isEmpty {
            return Single.error(LocalSecurityError.invalidPasscode)
        }

        let key = try? self.decryptionKey ?? randomDataGenerator.generateRandomData(of: keyLength)
        guard let appDataEncryptionKey = key else {
            return Single.error(LocalSecurityError.invalidPasscode)
        }

        do {
            let encryptedEncryptionKey = try cryptor.encrypt(using: passcode, data: appDataEncryptionKey)

            try keychain.set(encryptedEncryptionKey.base64EncodedString(), key: keychainPasscodeKey)

            decryptionKey = appDataEncryptionKey
            hasLockKeySet = true
            return Single.just(())
        } catch let error {
            return Single.error(error)
        }
    }

    func unlockAppUsing(passcode: String) -> Single<Void> {
        if !checkLocked() {
            return Single.just(())
        } else if passcode.isEmpty {
            return Single.error(LocalSecurityError.invalidPasscode)
        }

        do {
            if let storedPassword = try keychain.get(keychainPasscodeKey),
                let storedPasswordData = Data(base64Encoded: storedPassword) {

                let appEncryptionKey = try cryptor.decrypt(using: passcode, data: storedPasswordData)

                decryptionKey = appEncryptionKey
                return Single.just(())
            }
        } catch {
        }

        return Single.error(LocalSecurityError.invalidPasscode)
    }

    func clearAppLockPasscode() -> Single<Void> {
        if checkLocked() {
            return Single.error(LocalSecurityError.appLocked)
        }

        do {
            try keychain.remove(keychainPasscodeKey)
            decryptionKey = nil
            hasLockKeySet = false

            return Single.just(())
        } catch let error {
            return Single.error(error)
        }
    }

    func clearAppLock(usingPasscode passcode: String) -> Single<Void> {
        return unlockAppUsing(passcode: passcode)
            .flatMap {
                self.clearAppLockPasscode()
            }
    }

    func dropDecryptionKey() -> Single<Void> {
        do {
            try keychain.remove(keychainPasscodeKey)
            decryptionKey = nil
            hasLockKeySet = false

            return Single.just(())
        } catch let error {
            return Single.error(error)
        }
    }

    func unlockAppUsing(decryptionKey: Data) -> Single<Void> {
        self.decryptionKey = decryptionKey
        return Single.just(())
    }
}

private extension SecurityService {

    func checkLocked() -> Bool {
        return hasLockKeySet && decryptionKey == nil
    }
}
