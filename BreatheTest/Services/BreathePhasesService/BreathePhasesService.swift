//
//  BreathePhasesService.swift
//  BreatheTest
//
//  Created by Andrey Bogushev on 11/6/18.
//  Copyright © 2018 Andrey Bogushev. All rights reserved.
//

import Foundation

protocol BreathePhasesService {
    func breathePhases() -> ResultTask<[BreathePhase]>
}
