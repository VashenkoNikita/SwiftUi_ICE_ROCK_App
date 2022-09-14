//
//  Extension+Font.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 30.08.2022.
//

import SwiftUI

extension Font {
    static let myFont = MyFont()
}

struct MyFont {
    let poppins28 = Font.custom("Poppins", size: 28)
    let poppins20 = Font.custom("Poppins", size: 20)
    let poppins18 = Font.custom("Poppins", size: 18)
    let poppins16 = Font.custom("Poppins", size: 16)
    let poppins15 = Font.custom("Poppins", size: 15)
    let poppins14 = Font.custom("Poppins", size: 14)
    let poppins13 = Font.custom("Poppins", size: 13)
    let poppins12 = Font.custom("Poppins", size: 12)
}
