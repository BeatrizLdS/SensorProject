//
//  SensorModel.swift
//  SensorProject
//
//  Created by Beatriz Leonel da Silva on 29/07/24.
//

import Foundation

struct Sensor: Codable, Hashable {
    var parameter: String
    var name: String
    var minLimit: Double
    var maxLimit: Double
    
    init(parameter: ParameterProtocol, name: String, minLimit: Double, maxLimit: Double) {
        self.parameter = parameter.name
        self.name = name
        self.minLimit = minLimit
        self.maxLimit = maxLimit
    }
}

