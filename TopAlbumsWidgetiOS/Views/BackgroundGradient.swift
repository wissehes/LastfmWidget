//
//  BackgroundGradient.swift
//  TopAlbumsWidgetiOSExtension
//
//  Created by Wisse Hes on 09/06/2022.
//

import SwiftUI

struct BackgroundGradient: View {
    var color: Color? = nil
    @Environment(\.colorScheme) var colorScheme
    
    var gradientColor: Color {
        if colorScheme == .dark {
            return .black
        } else {
            return .white
        }
    }
    
    var secondColor: Color {
        if let color = color {
            return color
        } else {
            return .pink
        }
    }
    
    var body: some View {
        LinearGradient(colors: [gradientColor, secondColor], startPoint: .topTrailing, endPoint: .bottomLeading)
    }
}

struct BackgroundGradient_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundGradient()
    }
}
