//
//  MessageCell.swift
//  SensorProject
//
//  Created by Beatriz Leonel da Silva on 31/07/24.
//

import SwiftUI

struct MessageCell: View {
    let message: Message
    @State private var VStackHeigh: CGFloat = 0
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Sensor: ")
                            .fontWeight(.bold)
                        Text(message.sensor.name)
                            .fontWeight(.regular)
                            .lineLimit(1)
                    }
                    
                    VStack (alignment: .leading) {
                        Text("Valor minimo: \(String(format: "%.2f", message.sensor.minLimit))")
                        Text("Valor máximo: \(String(format: "%.2f", message.sensor.maxLimit))")
                    }
                    .font(.caption)
                    .foregroundColor(.black)
                }
                .background(GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            self.VStackHeigh = geometry.size.height
                        }
                })
                
                Spacer()
                
                icon
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(height: VStackHeigh)
            }
            .padding(.bottom, 8)
            
            HStack {
                Text("Valor registrado: ")
                    .fontWeight(.heavy)
                Spacer()
                Text("\(String(format: "%.2f", message.readedValue))")
                    .fontWeight(.heavy)
            }
            .foregroundColor(.red)
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundColor(.black)
        .padding()
        .background(Color.red.opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    
    var icon: Image {
        switch message.messageType {
        case .reachedMaxLimit:
            let sensorType = Parameter(rawValue: message.sensor.parameter)
            switch sensorType {
            case .temperature:
                return Image(systemName: "thermometer.sun")
            case .humidity:
                return Image(systemName: "humidity.fill")
            case .speed:
                return Image(systemName: "figure.run")
            case nil:
                return Image(systemName: "x.circle")
            }
        case .reachedMinLimt:
            let sensorType = Parameter(rawValue: message.sensor.parameter)
            switch sensorType {
            case .temperature:
                return Image(systemName: "thermometer.snowflake")
            case .humidity:
                return Image(systemName: "humidity")
            case .speed:
                return Image(systemName: "tortoise.fill")
            case nil:
                return Image(systemName: "x.circle")
            }
        }
    }
}

#Preview {
    MessageCell(message: Message(
        readedValue: 100,
        sensor: Sensor(
            parameter: Parameter.temperature,
            name: "Sensor",
            minLimit: 10,
            maxLimit: 30
        )
    ))
}
