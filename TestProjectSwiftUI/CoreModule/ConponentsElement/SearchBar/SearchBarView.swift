//
//  SearchBarView.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 14.07.2022.
//

import SwiftUI

struct SearchBarView: View {
    @Binding  var searchText: String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            
            TextField("", text: $searchText)
                .disableAutocorrection(true)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            searchText = ""
                            UIApplication.shared.endEditing()
                        }
                    ,alignment: .trailing
                )
                .placeholder(when: searchText.isEmpty) {
                    Text("Search by name or symbol...")
                }
               
        }
        .frame(height: 48)
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.backgroundElements)
        )
        .foregroundColor(searchText.isEmpty ? Color.theme.secondaryTint : Color.theme.accent)
        .font(Font.myFont.poppins16)
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchBarView(searchText: .constant(""))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
            SearchBarView(searchText: .constant(""))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
        }
    }
}
