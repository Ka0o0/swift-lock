//
//  ClearAppLockPasscodeUseCase.swift
//  Domain
//
//  Created by Kai Takac on 27/06/2017.
//  Copyright © 2017 Project-Ottawa. All rights reserved.
//

import Foundation
import RxSwift

public protocol ClearAppLockPasscodeUseCase {
    func clearAppLockPasscode() -> Single<Void>
}
