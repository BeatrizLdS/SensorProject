//
//  SubscriberServiceProtocol.swift
//  SensorProject
//
//  Created by Beatriz Leonel da Silva on 29/07/24.
//

import Foundation
import RMQClient

protocol MessengerSubscriberServiceProtocol {
    func listTopics(completion: @escaping ([String]) -> Void)
    func subscribe(topicName: String, completion: @escaping (Data)->Void)
    func closeConnection()
    func restartConnection()
}

class SubscriberRabbitMQ: MessengerSubscriberServiceProtocol {
    var connection: RMQConnection
    var channel: RMQChannel?
    
    static var shared = SubscriberRabbitMQ()
    
    init() {
        self.connection = RMQConnection(delegate: RMQConnectionDelegateLogger())
        connection.start()
        channel = connection.createChannel()
    }
    
    func restartConnection() {
        self.connection = RMQConnection(delegate: RMQConnectionDelegateLogger())
        connection.start()
        channel = connection.createChannel()
    }
    
    func closeConnection() {
        channel?.close()
        connection.close()
    }
    
    func listTopics(completion: @escaping ([String]) -> Void) {
        fetchTopics { topics in
            completion(topics)
        }
    }
    
    func subscribe(topicName: String, completion: @escaping (Data)->Void) {
        if let channelConnection = channel {
            let queue = channelConnection.queue(topicName, options: .durable)
            channelConnection.queueBind(topicName, exchange: topicName, routingKey: topicName)
            channel?.basicConsume(topicName, handler: { message in
                if let body = message.body {
                    completion(body)
                }
            })
            
        }
    }
    
    private func fetchTopics(completion: @escaping ([String]) -> Void) {
        let username = "guest"
        let password = "guest"
        let loginString = "\(username):\(password)"
        let loginData = loginString.data(using: .utf8)!
        let base64LoginString = loginData.base64EncodedString()

        var request = URLRequest(url: URL(string: "http://localhost:15672/api/exchanges")!)
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(String(describing: error))")
                completion([])
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    var topics = json.compactMap { $0["name"] as? String }
                    topics = topics.filter { topic in
                        !topic.hasPrefix("amq.") && topic != ""
                    }
                    completion(topics)
                } else {
                    completion([])
                }
            } catch {
                print("Error parsing JSON: \(error)")
                completion([])
            }
        }
        task.resume()
    }
}
