//
//  Message.swift
//  SensorProject
//
//  Created by Beatriz Leonel da Silva on 29/07/24.
//

import Foundation

struct Message: Codable, Hashable {
    let readedValue: Double
    let sensor: Sensor
    let messageType: MessageTypeCase
    
    init(readedValue: Double, sensor: Sensor) {
        self.readedValue = readedValue
        self.sensor = sensor
        self.messageType = readedValue >= sensor.maxLimit ? .reachedMaxLimit : .reachedMinLimt
    }
}

enum MessageTypeCase: String, Codable, Hashable {
    case reachedMaxLimit
    case reachedMinLimt
}
