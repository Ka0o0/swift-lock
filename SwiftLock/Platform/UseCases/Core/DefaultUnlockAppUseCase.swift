//
//  DefaultUnlockAppUseCase.swift
//  SwiftLock
//
//  Created by Kai Takac on 14.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

final class DefaultUnlockAppUseCase: UnlockAppUseCase {

    private let securityService: SecurityService

    init(securityService: SecurityService) {
        self.securityService = securityService
    }

    func unlockApp(using passcode: String) -> PrimitiveSequence<SingleTrait, Void> {
        return securityService.unlockAppUsing(passcode: passcode)
    }
}
