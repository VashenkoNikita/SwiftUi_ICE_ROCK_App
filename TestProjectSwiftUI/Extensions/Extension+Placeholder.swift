//
//  Extension+Placeholder.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 08.09.2022.
//

import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 0.7 : 0)
            self
        }
    }
}
