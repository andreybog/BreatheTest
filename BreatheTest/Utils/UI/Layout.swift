//
//  Layout.swift
//  BreatheTest
//
//  Created by Andrey Bogushev on 11/9/18.
//  Copyright © 2018 Andrey Bogushev. All rights reserved.
//

import UIKit

public typealias Constraint = (UIView, UIView) -> NSLayoutConstraint

public func equal<Axis, L>(_ from: KeyPath<UIView, L>,
                           _ to: KeyPath<UIView, L>,
                           constant: CGFloat = 0.0) -> Constraint
    where L: NSLayoutAnchor<Axis> {
        return { view, parent in
            view[keyPath: from].constraint(equalTo: parent[keyPath: to], constant: constant)
        }
}

public func equal<Axis, L>(_ to: KeyPath<UIView, L>, constant: CGFloat = 0.0) -> Constraint
    where L: NSLayoutAnchor<Axis> {
        return { view, parent in
            view[keyPath: to].constraint(equalTo: parent[keyPath: to], constant: constant)
        }
}

public func equal<L>(_ to: KeyPath<UIView, L>, constant: CGFloat) -> (UIView) -> NSLayoutConstraint
    where L: NSLayoutDimension {
        return { view in
            view[keyPath: to].constraint(equalToConstant: constant)
        }
}


private let _embedConstraints: [Constraint] = [
    equal(\.topAnchor),
    equal(\.bottomAnchor),
    equal(\.trailingAnchor),
    equal(\.leadingAnchor)
]

public let embedConstraints: (UIView, UIView) -> [NSLayoutConstraint] = { view, parent in
    return _embedConstraints.map { $0(view, parent) }
}

public func constrainSize(_ size: CGSize) -> (UIView) -> [NSLayoutConstraint] {
    return { view in
        [
            view.heightAnchor.constraint(equalToConstant: size.height),
            view.widthAnchor.constraint(equalToConstant: size.width)
        ]
    }
}


public extension Array where Element == Constraint {
    func apply(_ view: UIView, _ parent: UIView) -> [NSLayoutConstraint] {
        return map { $0(view, parent) }
    }
}
