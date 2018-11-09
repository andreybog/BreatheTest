//
//  SquareView.swift
//  BreatheTest
//
//  Created by Andrey Bogushev on 11/9/18.
//  Copyright © 2018 Andrey Bogushev. All rights reserved.
//

import UIKit

class SquareView: UIView {
    struct Props {
        enum Transform {
            case max
            case mid
            case min
            case current
        }
        
        static let initial = Props(transform: .mid, color: .yellow, duration: 1)
        
        let transform: Transform
        let color: UIColor
        let duration: TimeInterval
    }
    
    var model: Props = Props.initial {
        didSet { updateUI() }
    }
    
    private func updateUI() {
        UIView.animate(
            withDuration: model.duration,
            delay: 0.0,
            options: [.beginFromCurrentState, .curveEaseInOut],
            animations: {
                self.backgroundColor = self.model.color
                self.transform = self.convertTransform(self.model.transform)
            },
            completion: nil)
    }
    
    private func convertTransform(_ size: Props.Transform) -> CGAffineTransform {
        switch size {
        case .max:
            return CGAffineTransform.identity
        case .mid:
            return CGAffineTransform(scaleX: 0.75, y: 0.75)
        case .min:
            return CGAffineTransform(scaleX: 0.5, y: 0.5)
        case .current:
            return self.transform
        }
    }
}
