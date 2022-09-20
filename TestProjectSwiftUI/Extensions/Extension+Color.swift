//
//  Extension+Color.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 07.07.2022.
//

import SwiftUI

extension Color {
    static let theme = ThemeColor()
    static let gragient = GradientColor()
}

struct ThemeColor {
    let accent = Color("AccentColor")
    let background = Color("BackgoundColor")
    let backgroundAuth = Color("BackgroundColorAuth")
    let tintColor = Color("TintColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let secondaryTint = Color("SecondaryTintColor")
    let colorOverBackground = Color("ColorOverBackground")
    let backgroundElements = Color("BackgroundElements")
    let tfColor = Color("TextFieldColor")
}

struct GradientColor {
    let linearGradient = LinearGradient(colors: [Color("ColorOne"), Color("ColorTwo"), Color("ColorThree"), Color("ColorFour"), Color("ColorFive"), Color("ColorSix"), ], startPoint: .leading, endPoint: .trailing)
}
