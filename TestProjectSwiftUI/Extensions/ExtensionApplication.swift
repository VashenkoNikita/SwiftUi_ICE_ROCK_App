//
//  ExtensionApplication.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 14.07.2022.
//

import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
