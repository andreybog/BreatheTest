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
        action: #selector(actionStartButtonTouched),
        config: {
            $0.titleLabel?.numberOfLines = 2
            $0.titleLabel?.textAlignment = .center
            $0.titleLabel?.font = .systemFont(ofSize: 20)
        }
    )
    
    private lazy var phaseTitleLabel = UIView.makeLabel(text: nil) {
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 25)
    }
    
    private lazy var phaseDurationTimerLabel: TimerLabel = {
        let label = TimerLabel()
        label.text = "00:00"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25)
        return label
    }()
    
    private lazy var remainingLabel = UIView.makeLabel(text: Label.remainingTime) {
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 13)
    }
    
    private lazy var remainingTimerLabel: TimerLabel = {
        let label = TimerLabel()
        label.text = "00:00"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    private let squareView = SquareView()
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        addSubviews()
        updateUI()
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
        squareView.model = .initial
    }
    
    private func configurePhase(_ phase: Props.BreathePhase) {
        let phaseDuration = phase.duration

        initialViews.forEach { $0.isHidden = true }
        phaseViews.forEach { $0.isHidden = false }
        
        phaseTitleLabel.text = phase.title
        phaseDurationTimerLabel.setTimer(seconds: UInt(phaseDuration))
        remainingTimerLabel.setTimer(seconds: UInt(phase.remainingTime))
        
        squareView.model = SquareView.Props(
            transform: SquareView.Props.Transform(transform: phase.transform),
            color: phase.color,
            duration: phaseDuration
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now()+phaseDuration) {
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
        
        let stackConfig: (UIStackView) -> Void = { stack in
            stack.axis = .vertical
            stack.spacing = 10
            stack.alignment = .fill
            stack.distribution = .fill
        }
        
        stackConfig(centerStack)
        stackConfig(bottomStack)
        
        [squareView, centerStack, bottomStack].forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }
        
        
        // layout
        
        let centerYOffset = CGFloat(Int(view.bounds.height * 0.15))
        
        let center: [Constraint] = [
            equal(\.centerXAnchor),
            equal(\.centerYAnchor, constant: -centerYOffset)
        ]
        
        let bottom: [Constraint] = [
            equal(\.leadingAnchor, \.layoutMarginsGuide.leadingAnchor),
            equal(\.trailingAnchor, \.layoutMarginsGuide.trailingAnchor),
            equal(\.bottomAnchor, \.layoutMarginsGuide.bottomAnchor, constant: -30)
        ]
        
        let squareSide = CGFloat(Int(view.bounds.width * 0.70))
        
        NSLayoutConstraint.activate(center.apply(centerStack, view))
        NSLayoutConstraint.activate(bottom.apply(bottomStack, view))
        NSLayoutConstraint.activate(center.apply(squareView, view))
        
        NSLayoutConstraint.activate([
            equal(\.widthAnchor, constant: squareSide*0.75)(centerStack),
            equal(\.widthAnchor, constant: squareSide)(squareView),
            equal(\.heightAnchor, constant: squareSide)(squareView)
        ])
    }
}


fileprivate extension SquareView.Props.Transform {
    init(transform: BreatheExerciseViewController.Props.BreathePhase.Transform) {
        switch transform {
        case .max: self = .max
        case .mid: self = .mid
        case .min: self = .min
        case .current: self = .current
        }
    }
}
