//
//  RegisterViewModel.swift
//  SensorProject
//
//  Created by Beatriz Leonel da Silva on 31/07/24.
//

import Foundation

class RegisterViewModel: ObservableObject {
    @Published var isSensorReady = false
    @Published var isCreatingSensor = false
    
    @Published var isClientReady = false
    @Published var isCreatingClient = false
    
    @Published var selectedParameter: Parameter = .temperature
    @Published var sensorName: String = ""
    @Published var sensorMinLimitString: String = "" {
        didSet {
            if let value = Double(sensorMinLimitString) {
                sensorMinLimitDouble = value
            }
        }
    }
    @Published var sensorMaxLimitString: String = "" {
        didSet {
            if let value = Double(sensorMaxLimitString) {
                sensorMaxLimitDouble = value
            }
        }
    }
    @Published var topicsList: [Topic] = []
    @Published var selectedTopics = Set<Topic>()
    
    @Published private var sensorMinLimitDouble: Double = 0
    @Published private var sensorMaxLimitDouble: Double = 0
    
    private var repository = Repository()
    
    func getSelectesTopicsArray() -> [Topic] {
        return Array(selectedTopics)
    }
    
    func selectTopic(_ topic: Topic) {
        if isSelectedTopic(topic: topic) {
            selectedTopics.remove(topic)
        } else {
            selectedTopics.insert(topic)
        }
    }
    
    func isSelectedTopic(topic: Topic) -> Bool {
        return selectedTopics.contains(topic)
    }
    
    func listTopics() {
        repository.getAllTopics { [weak self] resultList in
            self?.topicsList = resultList
        }
    }
    
    func createSensor() -> Sensor {
        return Sensor.init(
            parameter: selectedParameter,
            name: sensorName,
            minLimit: sensorMinLimitDouble,
            maxLimit: sensorMaxLimitDouble
        )
    }
    
    func startViewModel() {
        DispatchQueue.main.async {
            self.isClientReady = false
            self.isSensorReady = false
            self.isCreatingSensor = false
            self.isCreatingClient = false
            self.sensorName = ""
            self.sensorMaxLimitString = ""
            self.sensorMinLimitString = ""
            self.selectedTopics = []
            self.topicsList = []
        }
    }
}
