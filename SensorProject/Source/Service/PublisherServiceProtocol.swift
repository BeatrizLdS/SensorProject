//
//  ServiceProtocol.swift
//  SensorProject
//
//  Created by Beatriz Leonel da Silva on 29/07/24.
//

import Foundation
import RMQClient

protocol MessengerPublisherServiceProtocol {
    func sendMessage(message: Data, channelKey: String)
    func deleteTopic(channelKey: String)
    func createCommunicationTopic(channelKey: String)
}

class PublisherRabbitMQ: MessengerPublisherServiceProtocol {
    let connection: RMQConnection
    var channel: RMQChannel?
    
    static let shared = PublisherRabbitMQ()
    
    init() {
        self.connection = RMQConnection(delegate: RMQConnectionDelegateLogger())
        connection.start()
    }
    
    func createCommunicationTopic(channelKey: String) {
        channel = connection.createChannel()
        if let channelConnection = channel {
            channelConnection.topic(channelKey, options: .durable)
            print("Criou canal nomeado")
        } else {
            print("Não deu bom")
        }
        
    }
    
    func sendMessage(message: Data, channelKey: String) {
        if let channelConnection = channel {
            channelConnection.basicPublish(message, routingKey: channelKey, exchange: channelKey, properties: [])
        }
    }
    
    func deleteTopic(channelKey: String) {
        guard let _ = channel else {
            print("Não existe tópico para ser deletado")
            return
        }
        channel!.queueDelete(channelKey)
        connection.close()
        
    }
}
