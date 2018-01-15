//
//  DefaultAppLockStatusUseCase.swift
//  SwiftLock
//
//  Created by Kai Takac on 14.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

final class DefaultAppLockStatusUseCase: AppLockStatusUseCase {

    var isLocked: Observable<Bool> {
        return securityService.isLocked
    }

    private let securityService: SecurityService

    init(securityService: SecurityService) {
        self.securityService = securityService
    }
}
