//
//  RegisterView.swift
//  SensorProject
//
//  Created by Beatriz Leonel da Silva on 31/07/24.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var vm = RegisterViewModel()
    
    var canCreateSensor: Bool {
        return !vm.sensorName.isEmpty && !vm.sensorMinLimitString.isEmpty && !vm.sensorMaxLimitString.isEmpty
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(alignment: .center) {
                    if !vm.isCreatingClient {
                        Button(action: {
                            Task {
                                withAnimation{
                                    vm.isCreatingSensor.toggle()
                                }
                            }
                        }, label: {
                            Text("Sensor")
                                .font(.title)
                                .fontWeight(.bold)
                        })
                        .buttonStyle(.customBordered)
                        .padding()
                        .transition(.opacity.animation(.easeInOut(duration: 0.4)))
                        .opacity(vm.isCreatingSensor ? 0.5 : 1)
                    }
                    if (!vm.isCreatingClient && !vm.isCreatingSensor) {
                        Divider()
                    }
                    if !vm.isCreatingSensor {
                        Button(action: {
                            Task {
                                withAnimation{
                                    vm.isCreatingClient.toggle()
                                }
                            }
                        }, label: {
                            Text("Cliente")
                                .font(.title)
                                .fontWeight(.bold)
                        })
                        .buttonStyle(.customBordered)
                        .padding()
                        .transition(.opacity.animation(.easeInOut(duration: 0.4)))
                        .opacity(vm.isCreatingClient ? 0.5 : 1)
                    }
                }
                if vm.isCreatingSensor {
                    Spacer()
                    VStack {
                        if (canCreateSensor) {
                            Button(action: {
                                Task {
                                    vm.isSensorReady.toggle()
                                }
                            }) {
                                Text("Criar sensor")
                                    .font(.title)
                                    .fontWeight(.heavy)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 8)
                                    .background(Color.blue)
                                    .cornerRadius(25)
                            }
                            .padding(.bottom, 20)
                        }
                        
                        List {
                            TextField("Nome do sensor", text: $vm.sensorName)
                            HStack {
                                TextField("Valor Mínimo", text: $vm.sensorMinLimitString)
                                    .keyboardType(.numbersAndPunctuation)
                                Divider()
                                TextField("Valor Máximo", text: $vm.sensorMaxLimitString)
                                    .keyboardType(.numbersAndPunctuation)
                            }
                            Picker("Parâmetro", selection: $vm.selectedParameter) {
                                Text("Temperaruta").tag(Parameter.temperature)
                                Text("Humidade").tag(Parameter.humidity)
                                Text("Velocidade").tag(Parameter.speed)
                            }
                        }
                    }
                    .transition(.move(edge: .bottom).animation(.easeInOut(duration: 0.5)))
                }
                
                if vm.isCreatingClient {
                    VStack {
                        if vm.selectedTopics.isEmpty {
                            Text("Selecione os tópicos:")
                                .fontWeight(.bold)
                                .padding(.bottom, 20)
                        } else {
                            Button(action: {
                                Task {
                                    vm.isClientReady.toggle()
                                }
                            }) {
                                Text("Iniciar cliente")
                                    .font(.title)
                                    .fontWeight(.heavy)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 8)
                                    .background(Color.blue)
                                    .cornerRadius(25)
                            }
                            .padding(.bottom, 20)
                        }
                        List {
                            VStack(alignment: .leading) {
                                ForEach(vm.topicsList) { topic in
                                    let parameter = Parameter(rawValue: topic.parameter)
                                    HStack(alignment: .center) {
                                        if vm.isSelectedTopic(topic: topic) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundColor(.blue)
                                                .frame(width: 30, height: 30)
                                        } else {
                                            Image(systemName: "circle")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundColor(.blue)
                                                .frame(width: 30, height: 30)
                                        }
                                        
                                        switch parameter {
                                        case .temperature:
                                            Text("\(topic.name): \nTemperatura")
                                        case .humidity:
                                            Text("\(topic.name): \nHumidade")
                                        case .speed:
                                            Text("\(topic.name): \nVelocidade")
                                        case nil:
                                            Text("\(topic.name): \nParâmetro desconhcido")
                                        }
                                    }
                                    .onTapGesture {
                                        vm.selectTopic(topic)
                                    }
                                }
                            }
                        }
                        
                    }
                    .transition(.move(edge: .bottom).animation(.easeInOut(duration: 0.5)))
                    .onAppear{
                        vm.listTopics()
                    }
                }
                
            }
            .onAppear {
                vm.startViewModel()
            }
            .navigationTitle("Registro de Usuário")
            .navigationBarTitleDisplayMode(.inline)
            .background(
                NavigationLink(
                    destination: SensorView(vm: SensorViewModel(
                        sensor: vm.createSensor()
                    )),
                    isActive: $vm.isSensorReady,
                    label: { EmptyView() }
                )
            )
            .background(
                NavigationLink(
                    destination: ClientView(topicsList: vm.getSelectesTopicsArray()),
                    isActive: $vm.isClientReady,
                    label: { EmptyView() }
                )
            )
        }
    }
}

#Preview {
    RegisterView()
}
