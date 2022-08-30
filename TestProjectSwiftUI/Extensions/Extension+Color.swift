//
//  Extension+Color.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 07.07.2022.
//

import SwiftUI

extension Color {
    static let theme = ThemeColor()
}

struct ThemeColor {
    let accent = Color("AccentColor")
    let background = Color("BackgoundColor")
    let backgroundAuth = Color("BackgroundColorAuth")
    let tintColor = Color("TintColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let secondaryTint = Color("SecondaryTintColor")
    let darkBackground = Color("LaunchBackground")
    let accentLaunch = Color("LaunchAccentColor")
}
