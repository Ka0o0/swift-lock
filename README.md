# SwiftLock 🛡

*Add local authentication to your app with a breeze*

## Features

- Local Authentication via passphrase
- Provides a cryptographic key which is released once the app is unlocked
- Biometric Authentication

## Usage

The framework uses RxSwift so it's highly recommended that you know the basics.

### Create a single instance of the SwiftLock 

```swift
let configuration = SwiftLockConfiguration(
	generatedKeyLengthInBytes: 64,
	keychainServiceId: "com.example.superapp.applock",
	...
)
let lockManager: SwiftLock = DefaultSwiftLock(configuration: configuration)
```

The `SwiftLock` class is designed as a factory class.
It allows the creation of different Use Cases.

### Get the lock status

```swift
let useCase = lockManager.makeAppLockStatusUseCase()
useCase.isLocked
	.subscribe(onSuccess: { isLocked in
		print(isLocked)
	})
	.disposedBy(disposeBag: disposeBag)
```

### Set the App's passcode

```swift
let useCase = lockManager.makeSetAppLockPasscodeUseCase()
useCase.setAppLock(passcode: "my passcode")
	.subscribe()
	.disposedBy(disposeBag: disposeBag)
```

### Unlock the App via passcode

```swift
let useCase = lockManager.makeUnlockAppUseCase()
useCase.unlock(using: "my passcode")
	.subscribe()
	.disposedBy(disposeBag: disposeBag)
```

### Enroll the User for Biometric authentication

SwiftLock also supports unlocking the app using Touch ID or Face ID.
Before enrolling a user, ensure that the app is unlocked and a passcode is set.

Also note that enabling biometric authentication stores the decryption key (not the passcode) plaintext in the Keychain.

```swift
let useCase = lockManager.makeBiometricAuthenticationEnrollmentUseCase()
// Adapt the explanation string to match the installed biometric scanner
useCase.enrollUserInBiometricAuthentication(explanation: "unlock the app using Touch ID")
	.subscribe()
	.disposedBy(disposeBag: disposeBag)
```

### Unlock the App 

```swift
let useCase = lockManager.makeBiometricAppUnlockUseCase()
// Adapt the explanation string to match the installed biometric scanner
useCase.unlockAppUsingBiometrics(explanation: "unlock the app using Touch ID")
	.subscribe()
	.disposedBy(disposeBag: disposeBag)
```

### Other

There are other Use Cases available. 
E.g. the framework provides the `AppDecryptionKeyUseCase` which allows the retrieval of a cryptographic key of the length of `generatedKeyLengthInBytes` specified in the configuration.
It can be used for data encryption and won't change until the app lock is cleared

## License

See [License](LICENSE).