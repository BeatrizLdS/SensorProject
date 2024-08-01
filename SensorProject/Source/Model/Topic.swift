//
//  Topic.swift
//  SensorProject
//
//  Created by Beatriz Leonel da Silva on 01/08/24.
//

import Foundation

struct Topic: Hashable, Identifiable {
    let id = UUID()
    var parameter: String
    var name: String
    
    init(parameter: Parameter, name: String) {
        self.parameter = parameter.rawValue
        self.name = name
    }
}
