//
//  SettingsView.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 01.08.2022.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            List {
                Section {
                    Link("Link to Icerock Dev website", destination: URL(string: "https://icerockdev.ru/")!)
                } header: {
                    Text("Icerock Dev")
                }

            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                    })
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
