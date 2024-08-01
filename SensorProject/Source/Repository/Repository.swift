//
//  Repository.swift
//  SensorProject
//
//  Created by Beatriz Leonel da Silva on 29/07/24.
//

import Foundation

class Repository {
    var publisher: MessengerPublisherServiceProtocol
    var subscriber: MessengerSubscriberServiceProtocol

    init() {
        self.publisher = PublisherRabbitMQ.shared
        self.subscriber = SubscriberRabbitMQ.shared
    }
    
    func restartRepositoryConnection() {
        subscriber.restartConnection()
    }
    
    func closeSubscriberConnection() {
        subscriber.closeConnection()
    }
    
    func subscribeInTopics(_ topicsList: [Topic], completion: @escaping (Message) -> Void) {
        topicsList.forEach { topic in
            subscriber.subscribe(topicName: "\(topic.parameter)/\(topic.name)") { [weak self] data in
                if let message = self?.dataToMessage(data: data) {
                    completion(message)
                }
            }
        }
    }
    
    func getAllTopics(completion: @escaping  (([Topic]) -> Void)) {
        subscriber.listTopics { resultList in
            let topicsList = resultList.map { input in
                let components = input.components(separatedBy: "/")
                return Topic(parameter: Parameter(rawValue: components[0])!, name: components[1])
            }
            completion(topicsList)
        }
    }
    
    func createCommunicationChannel(sensor: Sensor) {
        publisher.createCommunicationTopic(channelKey: "\(sensor.parameter)/\(sensor.name)")
    }
    
    func sendMessage(message: Message) {
        if let messageData = messageToData(message: message) {
            publisher.sendMessage(message: messageData, channelKey: "\(message.sensor.parameter)/\(message.sensor.name)")
        }
    }
    
    func deleteChannel(sensor: Sensor) {
        publisher.deleteTopic(channelKey: "\(sensor.parameter)/\(sensor.name)")
    }
    
    private func messageToData(message: Message) -> Data? {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(message)
            return data
        } catch {
            print("Error encoding message: \(error)")
            return nil
        }
    }
    
    private func dataToMessage(data: Data) -> Message? {
        let decoder = JSONDecoder()
        do {
            let message = try decoder.decode(Message.self, from: data)
            return message
        } catch {
            print("Erro para transformar em Menssagem")
            return nil
        }
    }
}
