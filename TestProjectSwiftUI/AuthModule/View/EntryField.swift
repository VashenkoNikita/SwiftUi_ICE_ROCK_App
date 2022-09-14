//
//  EntryField.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 13.09.2022.
//

import SwiftUI

struct EntryFieldEmail: View {
    
    var prompt: String
    @Binding var field: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 15) {
                Image(systemName: "envelope.fill")
                    .foregroundColor(field.isEmpty ? Color.theme.backgroundAuth.opacity(0.8) : Color.theme.accent)
                TextField("Email address", text: $field)
                    .foregroundColor(field.isEmpty ? Color.theme.secondaryTint : Color.theme.accent)
                    .font(Font.myFont.poppins16)
            }
            .padding(.bottom, 1)
            Divider()
                .background(Color.theme.secondaryTint.opacity(0.5))
            if !field.isEmpty {
                Text(prompt)
                    .foregroundColor(.theme.red)
                    .font(Font.myFont.poppins12)
            }
        }
    }
}

struct EntryFieldPassword: View {
    
    var placeHolder: String
    var prompt: String
    @Binding var field: String
    @Binding var isSecure: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 15) {
                Button(action: {
                    isSecure.toggle()
                }, label: {
                    if isSecure {
                        Image(systemName: "eye.fill")
                            .foregroundColor(field.isEmpty ? Color.theme.backgroundAuth.opacity(0.8) : Color.theme.accent)
                    } else {
                        Image(systemName: "eye.slash.fill")
                            .foregroundColor(field.isEmpty ? Color.theme.backgroundAuth.opacity(0.8) : Color.theme.accent)
                    }
                })
                .foregroundColor(Color.theme.accent.opacity(0.8))
                if isSecure {
                    TextField(placeHolder, text: $field)
                        .foregroundColor(field.isEmpty ? Color.theme.secondaryTint : Color.theme.accent)
                        .font(Font.myFont.poppins16)
                } else {
                    SecureField(placeHolder, text: $field)
                        .foregroundColor(field.isEmpty ? Color.theme.secondaryTint : Color.theme.accent)
                        .font(Font.myFont.poppins16)
                }
            }
            Divider()
                .background(Color.theme.tintColor.opacity(0.5))
            if !field.isEmpty {
                Text(prompt)
                    .foregroundColor(.theme.red)
                    .font(Font.myFont.poppins12)
            }
        }
    }
}
