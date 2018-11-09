//
//  UIView+Factory.swift
//  BreatheTest
//
//  Created by Andrey Bogushev on 11/9/18.
//  Copyright © 2018 Andrey Bogushev. All rights reserved.
//

import UIKit

extension UIView {
    static func makeButton(title: String?, target: Any, action: Selector, config: ((UIButton) -> Void)? = nil) -> UIButton {
        let button = UIButton(type: .system)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.setTitle(title, for: .normal)
        config?(button)

        return button
    }
    
    static func makeLabel(text: String?, config: ((UILabel) -> Void)? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .black
        config?(label)
        
        return label
    }
}
