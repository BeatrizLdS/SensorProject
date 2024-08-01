//
//  ContentView.swift
//  SensorProject
//
//  Created by Beatriz Leonel da Silva on 29/07/24.
//

import SwiftUI

struct SensorView: View {
    @ObservedObject var vm: SensorViewModel
    
    var body: some View {
        VStack (alignment: .leading) {
            SensorReadingCard(vm: vm)
            
            Text("Alertas Enviados:")
                .font(.title)
                .fontWeight(.heavy)
            
            if vm.messagesList.isEmpty {
                HStack(alignment: .center) {
                    Spacer()
                    Text("Nenhum alerta enviado!")
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding()
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack (spacing: 10) {
                        ForEach(vm.messagesList, id: \.self) { message in
                            MessageCell(message: message)
                        }
                    }
                }
                
            }
            Spacer()
        }
        .onAppear{
            vm.startChannel()
        }
        .padding()
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    SensorView(vm: SensorViewModel(
        sensor: Sensor(
            parameter: Parameter.temperature,
            name: "Sensor de temperatura",
            minLimit: 0,
            maxLimit: 30
        )
    ))
}
