//
//  Environment.swift
//  RMRobots
//
//  Created by Maksim Dmitrenko on 06.01.2021.
//

import Foundation

struct Environment {
  
    static var apiAuth: String? = Environment.variable(named: "ENV_API_KEY")
    static var apiHost: String = Environment.variable(named: "ENV_API_HOST") ?? "https://api.unsplash.com"
    
    static func variable(named name: String) -> String? {
        let processInfo = ProcessInfo.processInfo
        guard let value = processInfo.environment[name] else {
            return nil
        }
        
        return value
    }
}
