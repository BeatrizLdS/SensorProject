//
//  ClienteViewModel.swift
//  SensorProject
//
//  Created by Beatriz Leonel da Silva on 01/08/24.
//

import Foundation

class ClientViewModel: ObservableObject {
    let repository = Repository()
    @Published var subcribedTopics: [Topic]
    @Published var messagesList = Set<Message>()
    
    init(subcribedTopics: [Topic]) {
        self.subcribedTopics = subcribedTopics
    }
    
    func setTopics() {
        repository.subscribeInTopics(subcribedTopics) { [weak self] message in
            self?.messagesList.insert(message)
        }
    }
    
    func closeConnection() {
        repository.closeSubscriberConnection()
    }
    
    func restartConnection() {
        repository.restartRepositoryConnection()
    }
    
}
