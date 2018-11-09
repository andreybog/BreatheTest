//
//  BreatheExerciseViewController.swift
//  BreatheTest
//
//  Created by Andrey Bogushev on 11/8/18.
//  Copyright © 2018 Andrey Bogushev. All rights reserved.
//

import UIKit

private typealias Label = L10n.BreatheExercise.Label
private typealias Button = L10n.BreatheExercise.Button

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
    private lazy var startButton = UIView.makeButton(
        title: Button.start,
        target: self,
        action: #selector(actionStartButtonTouched)
    )
    
    private lazy var phaseTitleLabel: UILabel = UIView.makeLabel(text: nil) {
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private lazy var phaseDurationTimerLabel: TimerLabel = {
        let label = TimerLabel()
        label.text = "00:00"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var remainingLabel: UILabel = UIView.makeLabel(text: Label.remainingTime) {
        $0.textAlignment = .center
    }
    
    private lazy var remainingTimerLabel: TimerLabel = {
        let label = TimerLabel()
        label.text = "00:00"
        label.textAlignment = .center
        return label
    }()
        
    var model: Props = .initial(nil) {
        didSet { updateUI() }
    }
    
    var presenter: Presenter?
    
    private lazy var initialViews: [UIView] = {
        [startButton]
    }()
    
    private lazy var phaseViews: [UIView] = {
        [phaseTitleLabel, phaseDurationTimerLabel, remainingLabel, remainingTimerLabel]
    }()

    deinit {
        print("BreatheExerciseViewController deinit...")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        addSubviews()
        presenter?.setup()
    }
    

    //MARK: -
    //MARK: Actions
    
    @objc private func actionStartButtonTouched(_ sender: UIButton) {
        if case let Props.initial(config) = model {
            config?.onStart()
        }
    }
    
    //MARK: -
    //MARK: Private

    
    private func updateUI() {
        print(#function)
        print("model: \(model)")
        
        switch model {
        case .initial:
            initialConfig()
        case let .breathePhase(phase):
            configurePhase(phase)
        }
    }
    
    private func initialConfig() {
        initialViews.forEach { $0.isHidden = false }
        phaseViews.forEach { $0.isHidden = true }
    }
    
    private func configurePhase(_ phase: Props.BreathePhase) {
        initialViews.forEach { $0.isHidden = true }
        phaseViews.forEach { $0.isHidden = false }
        
        phaseTitleLabel.text = phase.title
        phaseDurationTimerLabel.setTimer(seconds: UInt(phase.duration))
        remainingTimerLabel.setTimer(seconds: UInt(phase.remainingTime))
        
        DispatchQueue.main.asyncAfter(deadline: .now()+phase.duration) {
            phase.onComplete?()
        }
    }
    
    
    //MARK: -
    //MARK: Layout
    
    private func addSubviews() {
        // adding subviews
        
        let centerStack = UIStackView(arrangedSubviews: [
            startButton,
            phaseTitleLabel,
            phaseDurationTimerLabel
        ])
        
        let bottomStack = UIStackView(arrangedSubviews: [
            remainingLabel,
            remainingTimerLabel,
        ])
        
        
        centerStack.axis = .vertical
        centerStack.spacing = 15
        centerStack.alignment = .fill
        centerStack.distribution = .fill
        
        bottomStack.axis = .vertical
        bottomStack.spacing = 15
        bottomStack.alignment = .fill
        bottomStack.distribution = .fill
        
        [
            centerStack,
            bottomStack
        ]
        .forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }

        // layout
        
        let center: [Constraint] = [
            equal(\.centerXAnchor),
            equal(\.centerYAnchor)
        ]
        
        let bottom: [Constraint] = [
            equal(\.leadingAnchor, \.layoutMarginsGuide.leadingAnchor),
            equal(\.trailingAnchor, \.layoutMarginsGuide.trailingAnchor),
            equal(\.bottomAnchor, \.layoutMarginsGuide.bottomAnchor, constant: -30)
        ]
        
        let squareSide = CGFloat(Int(view.bounds.width * 0.66))
        
        NSLayoutConstraint.activate(
            center.apply(centerStack, view)
            +
            [equal(\UIView.widthAnchor, constant: squareSide)(centerStack)]
            +
            bottom.apply(bottomStack, view)
        )
    }
}
