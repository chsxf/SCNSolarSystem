//
//  Functions.swift
//  SCNSolarSystem
//
//  Created by Christophe on 26/12/2021.
//

import Foundation
import Combine

class Functions {
    static func load<T: Decodable>(_ filename: String) -> T {
        let data: Data
        
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
            fatalError("Could not find \(filename) in the bundle")
        }
        
        do {
            data = try Data(contentsOf: file)
        }
        catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        }
        catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
}
