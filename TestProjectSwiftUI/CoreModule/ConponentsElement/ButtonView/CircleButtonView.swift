//
//  CircleButton.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 12.07.2022.
//

import SwiftUI

struct CircleButtonView: View {
    let iconName: String
    let opacityBackground: CGFloat
    
    var body: some View {
        Image(iconName)
            .font(.headline)
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .foregroundColor(Color.theme.backgroundElements)
                    .opacity(opacityBackground)
            )
    }
}

struct CircleButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CircleButtonView(iconName: "", opacityBackground: 0.5)
                .padding()
                .previewLayout(.sizeThatFits)
            CircleButtonView(iconName: "", opacityBackground: 0.5)
                .padding()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
