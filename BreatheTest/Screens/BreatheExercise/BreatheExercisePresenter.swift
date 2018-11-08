//
//  BreatheExercisePresenter.swift
//  BreatheTest
//
//  Created by Andrey Bogushev on 11/8/18.
//  Copyright © 2018 Andrey Bogushev. All rights reserved.
//

import UIKit

class BreatheExercisePresenter: Presenter {
    var output: ((BreatheExerciseViewController.Props) -> Void)?
    
    private let dataProvider: () -> ResultTask<[BreathePhase]>
    private var phaseIterator: BreathePhaseIterator?
    
    init(dataProvider: @escaping () -> ResultTask<[BreathePhase]>) {
        self.dataProvider = dataProvider
    }
    
    func setup() {
        performNextPhaseOrReset()
    }
    
    //MARK: -
    //MARK: Private
    
    private func loadPhases() {
        weak var weak = self
        
        phaseIterator = nil
        
        dataProvider()
            .addSuccess { phases in
                weak?.phaseIterator = BreathePhaseIterator(phases: phases)
            }
            .addFailure { error in
                print("Error: ", #file, #function, "\n\(error.localizedDescription)")
            }
            .addCompletion { _ in
                weak?.performNextPhaseOrReset()
            }
    }
    
    private func performNextPhaseOrReset() {
        if var phase = phaseIterator?.next() {
            phase.onComplete = self.performNextPhaseOrReset
            output?(.breathePhase(phase))
        }
        else {
            let loadProps = BreatheExerciseViewController.Props.Initial(onStart: self.loadPhases)
            output?(.initial(loadProps))
        }
    }
}

private final class BreathePhaseIterator: IteratorProtocol {
    private typealias PropsResult = BreatheExerciseViewController.Props.BreathePhase
    
    private var phases: [BreathePhase]
    private var remainingTime: TimeInterval
    
    init(phases: [BreathePhase]) {
        self.phases = phases.reversed()
        remainingTime = phases.reduce(0, { $0 + $1.duration })
    }
    
    func next() -> BreatheExerciseViewController.Props.BreathePhase? {
        guard !phases.isEmpty else { return nil }
        return convert(phases.removeLast())
    }
    
    private func convert(_ phase: BreathePhase) -> PropsResult {
        defer { remainingTime -= phase.duration }
        
        return PropsResult(
            transform: transform(for: phase.kind),
            color: phase.color,
            title: phase.kind.description,
            duration: phase.duration,
            remainingTime: remainingTime,
            onComplete: nil
        )
    }
    
    private func transform(for breathKind: BreathePhase.Kind) -> PropsResult.Transform {
        switch breathKind {
        case .inhale: return .max
        case .exhale: return .min
        case .hold: return .current
        }
    }
}

