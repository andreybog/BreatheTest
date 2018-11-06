//
//  UIColor+Extensions.swift
//  BreatheTest
//
//  Created by Andrey Bogushev on 11/6/18.
//  Copyright © 2018 Andrey Bogushev. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init?(hexString: String, prefix: String? = nil) {
        let resultString = prefix.map(dropPrefix)?(hexString) ?? hexString
        
        guard let hex = UInt(resultString, radix: 16) else { return nil }
        self.init(hex: hex)
    }
    
    convenience init(hex: UInt) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

private func dropPrefix(_ prefix: String) -> (String) -> String {
    return { value in
        guard value.hasPrefix(prefix) else { return value }
        return String(value.dropFirst(prefix.count))
    }
}
