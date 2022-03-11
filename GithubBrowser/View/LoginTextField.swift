//
//  LoginTextView.swift
//  GithubBrowser
//
//  Created by rikucherry on 2022/03/11.
//

import SwiftUI

struct LoginTextField: View {
    let hintString: String
    let inputString: Binding<String>
    var isSecure = false
    
    var body: some View {
        if isSecure {
            SecureField(hintString, text: inputString).customizeTextField(textContent: .password)
        } else {
            TextField(hintString, text: inputString).customizeTextField(textContent: .username)
        }
    }
}

extension View {
    func customizeTextField(textContent: UITextContentType) -> some View {
        return self.textContentType(textContent)
            .font(Font.system(size: 24, weight: .regular, design: .default))
            .foregroundColor(Color.black)
            .frame(height: 60)
            .padding(.horizontal, 16)
            .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.accentColor, lineWidth: 2))
            .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
    }
}

struct LoginTextView_Previews: PreviewProvider {
    @State static var input: String = ""
    static var previews: some View {
        LoginTextField(hintString: "test", inputString: $input)
    }
}
