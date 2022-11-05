//
//  FilledRoundedCornerButtonStyle.swift
//  Redditech
//
//  Created by Pierre Jeannin on 12/10/2022.
//

import SwiftUI

struct FilledRoundedCornerButtonStyle: ButtonStyle {
    var vPadding: CGFloat
    var hPadding: CGFloat
    var bgColor: Color
    var fgColor: Color
    var cornerRadius: CGFloat
    
    init(vPadding: CGFloat = 8, hPadding: CGFloat = 18, bgColor: Color = Color("PrimaryColor"), fgColor: Color = Color("SecondaryColor"), cornerRadius: CGFloat = 10) {
        self.vPadding = vPadding
        self.hPadding = hPadding
        self.bgColor = bgColor
        self.fgColor = fgColor
        self.cornerRadius = cornerRadius
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, vPadding)
            .padding(.horizontal, hPadding)
            .background(bgColor)
            .foregroundColor(fgColor)
            .cornerRadius(cornerRadius)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(), value: 2)
        
    }
}
