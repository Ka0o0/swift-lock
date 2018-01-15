//
//  CryptoSupport.swift
//  SwiftLock
//
//  Created by Kai Takac on 13.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation

///
/// Converts a single hexadecimal digit encoded as a Unicode Scalar to it's corresponding value.
///
/// - parameter c: A Unicode scalar in the set 0..9a..fA..F
/// - returns: the hexadecimal value of the digit
///
func convertHexDigit(char: UnicodeScalar) -> UInt8 {
    switch char {
    case UnicodeScalar("0")...UnicodeScalar("9"): return UInt8(char.value - UnicodeScalar("0").value)
    case UnicodeScalar("a")...UnicodeScalar("f"): return UInt8(char.value - UnicodeScalar("a").value + UInt32(0xa))
    case UnicodeScalar("A")...UnicodeScalar("F"): return UInt8(char.value - UnicodeScalar("A").value + UInt32(0xa))
    default: fatalError("convertHexDigit: Invalid hex digit")
    }
}

///
/// Converts a string of hexadecimal digits to a Swift array.
///
/// - parameter s: the hex string (must contain an even number of digits)
/// - returns: a Swift array
///
public func arrayFrom(hexString: String) -> [UInt8] {
    var g = hexString.unicodeScalars.makeIterator()
    var a: [UInt8] = []
    while let msn = g.next() {
        if let lsn = g.next() {
            a += [(convertHexDigit(char: msn) << 4 | convertHexDigit(char: lsn))]
        } else {
            fatalError("arrayFromHexString: String must contain even number of characters")
        }
    }
    return a
}
