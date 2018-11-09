//
//  SafeBox.swift
//  BreatheTest
//
//  Created by Andrey Bogushev on 11/7/18.
//  Copyright © 2018 Andrey Bogushev. All rights reserved.
//

import Foundation

class SafeBox<T> {
    private let lock = NSRecursiveLock()
    private var _value: T
    
    var value: T {
        get { return lock.do { _value } }
        set { lock.do { _value = newValue } }
    }
    
    init(_ value: T) {
        self._value = value
    }
}

infix operator <-: AssignmentPrecedence

extension SafeBox {
    static func <-(lhs: SafeBox<T>, rhs: T) {
        lhs.value = rhs
    }
}

extension SafeBox: Equatable where T: Equatable {
    static func ==(lhs: SafeBox<T>, rhs: SafeBox<T>) -> Bool {
        return lhs.value == rhs.value
    }
    
    static func ==(lhs: SafeBox<T>, rhs: T) -> Bool {
        return lhs.value == rhs
    }
}
