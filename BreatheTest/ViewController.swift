//
//  ViewController.swift
//  BreatheTest
//
//  Created by Andrey Bogushev on 11/6/18.
//  Copyright © 2018 Andrey Bogushev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let service: BreathePhasesService = BundleBreathePhasesService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        service.breathePhases()
            .addSuccess { phases in
                print(phases)
            }
            .addFailure { error in
                print(error.localizedDescription)
            }
    }
}

