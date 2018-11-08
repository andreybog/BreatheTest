//
//  BreatheExerciseViewController.swift
//  BreatheTest
//
//  Created by Andrey Bogushev on 11/8/18.
//  Copyright © 2018 Andrey Bogushev. All rights reserved.
//

import UIKit

extension BreatheExerciseViewController {
    enum Props {
        struct Initial {
            var onStart: () -> Void
        }
        
        struct BreathePhase {
            enum Transform {
                case max
                case mid
                case min
                case current
            }
            
            let transform: Transform
            let color: UIColor
            let title: String
            let duration: TimeInterval
            let remainingTime: TimeInterval
            var onComplete: (() -> Void)?
        }
        
        case initial(Initial?)
        case breathePhase(BreathePhase)
    }
}

class BreatheExerciseViewController: UIViewController {
    
    var model: Props = .initial(nil) {
        didSet { updateUI() }
    }
    
    var presenter: Presenter?

    deinit {
        print("BreatheExerciseViewController deinit...")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        constrainSubviews()
        presenter?.setup()
    }
    
    //MARK: -
    //MARK: Private
    
    private func updateUI() {
        print(#function)
        print("model: \(model)")
    }
    
    private func addSubviews() {
        
    }
    
    private func constrainSubviews() {
        
    }
}
