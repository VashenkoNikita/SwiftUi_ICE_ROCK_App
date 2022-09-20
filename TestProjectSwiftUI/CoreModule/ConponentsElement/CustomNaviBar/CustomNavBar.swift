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
    var rightButtonName: String?
    var action: () -> Void
    
    init(rightButtonName: String?, isPresentedEditButton: Bool, @ViewBuilder content: () -> Content, action: @escaping () -> Void) {
        self.isPresentedEditButton = isPresentedEditButton
        self.content = content()
        self.rightButtonName = rightButtonName
        self.action = action
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
            Button(action: action) {
                Image(rightButtonName ?? "")
                    .font(Font.myFont.poppins20)
                    .padding(.all, 24)
                    .opacity(isPresentedEditButton ? 1 : 0)
                    .disabled(isPresentedEditButton)
            }
        }
        
        .frame(height: UIScreen.main.bounds.height / 7, alignment: .bottom)
        .background(Color.theme.colorOverBackground)
        .cornerRadius(radius: 32, corners: [.bottomLeft, .bottomRight])
    }
}

struct CustomNavBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavBar(rightButtonName: "Edit_Pencil", isPresentedEditButton: true) {
            Text("Profile")
                .foregroundColor(Color.theme.accent)
                .font(Font.myFont.poppins20)
        } action:  {
            
        }
    }
}
