//
//  BundleBreathePhasesService.swift
//  BreatheTest
//
//  Created by Andrey Bogushev on 11/7/18.
//  Copyright © 2018 Andrey Bogushev. All rights reserved.
//

import Foundation

class BundleBreathePhasesService: BreathePhasesService {
    
    private static func url(forResource name: String) throws -> URL {
        guard let url = Bundle(for: BundleToken.self).url(forResource: name, withExtension: "json") else {
            let message = "Bundle resource not found: \(name).json"
            let error = NSError(domain: "BundleBreathePhasesDomain", code: 1, userInfo: [
                NSLocalizedDescriptionKey: message])
            throw error
        }
        
        return url
    }
    
    func breathePhases() -> ResultTask<[BreathePhase]> {
        do {
            let url = try BundleBreathePhasesService.url(forResource: "breathe_phases")
            let data = try Data(contentsOf: url)
            let phases = try JSONDecoder().decode([BreathePhase].self, from: data)
            return .async { $0.success(phases) }
        } catch {
            return .async { $0.failure(error) }
        }
    }
}

private final class BundleToken {}
