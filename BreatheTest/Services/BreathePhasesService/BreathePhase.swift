//
//  BreathePhase.swift
//  BreatheTest
//
//  Created by Andrey Bogushev on 11/6/18.
//  Copyright © 2018 Andrey Bogushev. All rights reserved.
//

import UIKit

private typealias Label = L10n.BreathePhase.Kind

struct BreathePhase {
    enum Kind: String, Decodable {
        case inhale
        case exhale
        case hold
        
        var description: String {
            switch self {
            case .inhale: return Label.inhale
            case .exhale: return Label.exhale
            case .hold: return Label.hold
            }
        }
    }
    
    let kind: Kind
    let duration: Double
    let color: UIColor
}

extension BreathePhase: Decodable {
    private enum CodingKeys: String, CodingKey {
        case type
        case duration
        case color
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        kind = try container.decode(.type)
        duration = try container.decode(.duration)
        
        let hexString: String = try container.decode(.color)
        
        guard let hexColor = UIColor(hexString: hexString, prefix: "#") else {
            let context = DecodingError.Context(
                codingPath: container.codingPath,
                debugDescription: "Can't decode color from hex string: \(hexString)"
            )
            
            throw DecodingError.dataCorrupted(context)
        }
        
        color = hexColor
    }
}
