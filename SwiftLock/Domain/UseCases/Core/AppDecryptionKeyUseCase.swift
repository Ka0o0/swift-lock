//
//  AppDecryptionKeyUseCase.swift
//  SwiftLock
//
//  Created by Kai Takac on 13.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

public protocol AppDecryptionKeyUseCase {

    var currentDecryptionKey: Observable<Data?> { get }
}
