//
//  ButtonStyle.swift
//  SensorProject
//
//  Created by Beatriz Leonel da Silva on 29/07/24.
//

import Foundation
import SwiftUI

struct CustomBorderedButton: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
      configuration.label
          .foregroundColor(.white)
          .padding(.horizontal, 15)
          .padding(.vertical, 8)
          .background(Color.blue)
          .clipShape(Capsule())
  }
}

extension ButtonStyle where Self == CustomBorderedButton {
    static var customBordered: CustomBorderedButton {
        return CustomBorderedButton()
    }
}
