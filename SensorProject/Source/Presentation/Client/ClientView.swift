//
//  ClientView.swift
//  SensorProject
//
//  Created by Beatriz Leonel da Silva on 01/08/24.
//

import SwiftUI

struct ClientView: View {
    @ObservedObject var vm: ClientViewModel
    
    init(topicsList: [Topic]) {
        vm = ClientViewModel(subcribedTopics: topicsList)
    }
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack (spacing: 10) {
                    ForEach(Array(vm.messagesList), id: \.self) { message in
                        MessageCell(message: message)
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Alertas recebidos")
        .onAppear {
            vm.restartConnection()
            vm.setTopics()
        }
        .onDisappear{
            DispatchQueue.global(qos: .background).async {
                vm.closeConnection()
            }
        }
    }
}

#Preview {
    ClientView(topicsList: [])
}
