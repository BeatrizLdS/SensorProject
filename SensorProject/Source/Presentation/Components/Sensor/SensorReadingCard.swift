//
//  SensorReadingCard.swift
//  SensorProject
//
//  Created by Beatriz Leonel da Silva on 31/07/24.
//

import SwiftUI

struct SensorReadingCard: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: SensorViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text("\(vm.sensor.name)")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                Button(action: {
                    vm.deleteChannel()
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "trash.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.red)
                        .frame(width: 40, height: 40)
                })
            }
            
            if let readedValue = vm.lastRecordedValue {
                HStack {
                    Text("Ultima leitura feita: ")
                    Text(String(format: "%.2f", readedValue))
                }
                .foregroundColor(Color.black.opacity(0.7))
            } else {
                Text("Nenhuma leitura realizada")
                    .foregroundColor(Color.black.opacity(0.7))
            }
            
            Divider()
                .frame(height: 2)
                .background(Color.blue.opacity(0.5))
            
            HStack {
                TextField("Enter a number", text: $vm.currentValue)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    
                Button("Fazer leitura") {
                    vm.doReading()
                }
                .buttonStyle(.customBordered)
            }

        }
        .padding()
        .background(
            Color.gray.opacity(0.2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    SensorReadingCard(vm: SensorViewModel(
        sensor: Sensor(
            parameter: Parameter.temperature,
            name: "Sensor de temperatura",
            minLimit: 0,
            maxLimit: 30
        )
    ))
}
