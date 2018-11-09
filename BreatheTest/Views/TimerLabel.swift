//
//  TimerLabel.swift
//  BreatheTest
//
//  Created by Andrey Bogushev on 11/9/18.
//  Copyright © 2018 Andrey Bogushev. All rights reserved.
//

import UIKit

class TimerLabel: UILabel {
    private var seconds: UInt = 0
    private var timer: Timer?
    
    func setTimer(seconds: UInt) {
        timer?.invalidate()

        self.seconds = seconds
        updateUI()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }
    
    private func tick() {
        guard seconds > 0 else {
            timer?.invalidate()
            return
        }
        
        seconds -= 1
        updateUI()
    }
    
    private func updateUI() {
        text = stringFromSeconds(seconds)
    }
    
    private func stringFromSeconds(_ seconds: UInt) -> String {
        let min = seconds / 60
        let sec = seconds % 60
        return  String(format: "%02u:%02u", min, sec)
    }
}
