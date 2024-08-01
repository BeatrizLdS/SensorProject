//
//  SensorProjectApp.swift
//  SensorProject
//
//  Created by Beatriz Leonel da Silva on 29/07/24.
//

import SwiftUI

@main
struct SensorProjectApp: App {
    var body: some Scene {
        WindowGroup {
            RegisterView()
                .environment(\.colorScheme, .light)
        }
    }
}
