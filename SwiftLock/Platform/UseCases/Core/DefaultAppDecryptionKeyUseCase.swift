//
//  DefaultAppDecryptionKeyUseCase.swift
//  SwiftLock
//
//  Created by Kai Takac on 14.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

final class DefaultAppDecryptionKeyUseCase: AppDecryptionKeyUseCase {

    var currentDecryptionKey: Observable<Data?> {
        return securityService.decryptionKeyObservable
    }

    private let securityService: SecurityService

    init(securityService: SecurityService) {
        self.securityService = securityService
    }
}
