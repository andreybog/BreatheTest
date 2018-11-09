//
//  NSLocking+Extensions.swift
//  BreatheTest
//
//  Created by Andrey Bogushev on 11/7/18.
//  Copyright © 2018 Andrey Bogushev. All rights reserved.
//

import Foundation

extension NSLocking {
    func `do`<Result>(action: () -> Result) -> Result {
        lock()
        defer { unlock() }
        
        return action()
    }
}
