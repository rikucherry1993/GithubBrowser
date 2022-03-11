//
//  LoginButton.swift
//  GithubBrowser
//
//  Created by rikucherry on 2022/03/11.
//

import SwiftUI

struct LoginButton: View {
    let label: String
    var backgroundColor: Color = Color.accentColor
    var foregroundColor: Color = Color.white
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(Font.system(size: 24, weight:.heavy, design: .default))
                .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                .foregroundColor(foregroundColor)
        }
        .buttonStyle(changeOpacityStyle(color: backgroundColor))
    }
}

struct changeOpacityStyle: ButtonStyle {
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(RoundedRectangle(cornerRadius: 8).fill(color))
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

struct LoginButton_Previews: PreviewProvider {
    static var previews: some View {
        LoginButton(label: "Button", action: {})
    }
}
