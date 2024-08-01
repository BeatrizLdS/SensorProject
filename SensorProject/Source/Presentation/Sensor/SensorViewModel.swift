//
//  ViewModel.swift
//  SensorProject
//
//  Created by Beatriz Leonel da Silva on 29/07/24.
//

import Foundation

class SensorViewModel: ObservableObject {
    var repository = Repository()
    
    @Published var currentValue: String = ""
    @Published var sensor: Sensor
    @Published var lastRecordedValue: Double?
    @Published var messagesList: [Message] = []
    
    init(sensor: Sensor) {
        self.sensor = sensor
    }
    
    func startChannel() {
        repository.createCommunicationChannel(sensor: sensor)
    }
    
    func doReading() {
        if let readedValue = convertStringToDouble(currentValue) {
            lastRecordedValue = readedValue
            if !isValid(readedValue) {
                let newMessage = Message(readedValue: readedValue, sensor: sensor)
                sendSensorAlert(message: newMessage)
                messagesList.append(newMessage)
            }
        }
    }
    
    private func convertStringToDouble(_ input: String) -> Double? {
        return Double(input)
    }
    
    func deleteChannel() {
        repository.deleteChannel(sensor: sensor)
        messagesList = []
    }
    
    private func isValid(_ value: Double) -> Bool {
        return value > sensor.minLimit && value < sensor.maxLimit
    }
    
    private func sendSensorAlert(message: Message) {
        repository.sendMessage(message: message)
    }
}
