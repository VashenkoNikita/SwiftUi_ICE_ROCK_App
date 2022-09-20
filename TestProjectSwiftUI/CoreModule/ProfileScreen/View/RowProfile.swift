//
//  RowProfile.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 31.08.2022.
//

import SwiftUI

struct RowProfile: View {
    var text: String
    
    init(text: String) {
        self.text = text
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Text(text)
                .font(Font.myFont.poppins15)
                .padding(.leading, 16)
                .foregroundColor(Color.theme.accent)
            Spacer()
            Image("Chevron_Left")
                .font(Font.myFont.poppins20)
                .padding(.horizontal, 16)
                .rotationEffect(Angle(degrees: 180))
        }
        .frame(height: UIScreen.main.bounds.height / 22)
    }
}

struct RowProfile_Previews: PreviewProvider {
    static var previews: some View {
        RowProfile(text: "Security")
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}


