//
//  FilledRoundedCornerButtonStyle.swift
//  Redditech
//
//  Created by Pierre Jeannin on 12/10/2022.
//

import SwiftUI

struct FilledRoundedCornerButtonStyle: ButtonStyle {
    var padding: CGFloat = 8
    var bgColor: Color = Color("PrimaryColor")
//    var bgColor: Color = .green
    var fgColor: Color = Color("SecondaryColor")
    var cornerRadius: CGFloat = 10
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(padding)
            .background(bgColor)
            .foregroundColor(fgColor)
            .cornerRadius(cornerRadius)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(), value: 2)
        
    }
}
