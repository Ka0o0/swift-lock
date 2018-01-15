//
//  DefaultSetAppLockPasscodeUseCase.swift
//  SwiftLock
//
//  Created by Kai Takac on 14.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

final class DefaultSetAppLockPasscodeUseCase: SetAppLockPasscodeUseCase {

    private let securityService: SecurityService

    init(securityService: SecurityService) {
        self.securityService = securityService
    }

    func setAppLock(passcode: String) -> Single<Void> {
        return securityService.setAppLock(passcode: passcode)
    }
}
