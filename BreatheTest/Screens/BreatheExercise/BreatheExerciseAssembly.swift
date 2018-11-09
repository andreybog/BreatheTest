//
//  BreatheExerciseAssembly.swift
//  BreatheTest
//
//  Created by Andrey Bogushev on 11/9/18.
//  Copyright © 2018 Andrey Bogushev. All rights reserved.
//

import UIKit

class BreatheExerciseAssembly {
    static func breatheExercise() -> UIViewController {
        let vc = BreatheExerciseViewController()
        let phasesService = BundleBreathePhasesService()
        let presenter = BreatheExercisePresenter(dataProvider: phasesService.breathePhases)
        
        vc.presenter = presenter
        presenter.output = { [weak vc] props in
            vc?.model = props
        }
        
        return vc
    }
}
