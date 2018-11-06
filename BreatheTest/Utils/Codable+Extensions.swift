//
//  Codable+Extensions.swift
//  BreatheTest
//
//  Created by Andrey Bogushev on 11/7/18.
//  Copyright © 2018 Andrey Bogushev. All rights reserved.
//

import Foundation

extension KeyedDecodingContainerProtocol {
    func decode<T: Decodable>(_ key: Key) throws -> T {
        return try decode(T.self, forKey: key)
    }
    
    func decodeIfPresent<T: Decodable>(_ key: Key) throws -> T? {
        return try decodeIfPresent(T.self, forKey: key)
    }
}
