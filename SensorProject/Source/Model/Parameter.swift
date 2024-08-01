//
//  ParameterModel.swift
//  SensorProject
//
//  Created by Beatriz Leonel da Silva on 29/07/24.
//

import Foundation

protocol ParameterProtocol: Codable {
    var name: String { get }
}

enum Parameter: String, ParameterProtocol, Codable {
    case temperature
    case humidity
    case speed

    var name: String {
        return self.rawValue
    }
}
