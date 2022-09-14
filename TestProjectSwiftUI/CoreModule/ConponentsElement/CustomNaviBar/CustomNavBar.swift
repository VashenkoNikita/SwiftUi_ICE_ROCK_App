//
//  CustomNavBar.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 31.08.2022.
//

import SwiftUI

struct CustomNavBar<Content: View>: View {
    let content: Content
    
    @Environment(\.presentationMode) var presentationMode
    var isPresentedEditButton: Bool = true
    
    init( isPresentedEditButton: Bool, @ViewBuilder content: () -> Content) {
        self.isPresentedEditButton = isPresentedEditButton
        self.content = content()
    }
    
    var body: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image("Chevron_Left")
                    .font(Font.myFont.poppins20)
                    .padding(.all, 24)
            })
            Spacer()
            content
            Spacer()
            Button(action: {
            }, label: {
                Image("Edit_Pencil")
                    .font(Font.myFont.poppins20)
                    .padding(.all, 24)
                    .opacity(isPresentedEditButton ? 1 : 0)
            })
        }
        
        .frame(height: 104, alignment: .bottom)
        .background(Color.theme.colorOverBackground)
        .cornerRadius(radius: 32, corners: [.bottomLeft, .bottomRight])
    }
}

struct CustomNavBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavBar( isPresentedEditButton: true) {
            Text("Profile")
                .foregroundColor(Color.theme.accent)
                .font(Font.myFont.poppins20)
        }
    }
}
