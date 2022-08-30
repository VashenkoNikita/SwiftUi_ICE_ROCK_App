//
//  ContentView.swift
//  TestProjectSwiftUI
//
//  Created by NikitaV on 02.07.2022.
//

import SwiftUI

struct ContentView: View {
    
    @State var index = 0
    
    var body: some View {
        GeometryReader { _ in
            VStack {
                VStack {
                    Text("ICE")
                        .bold()
                        .font(.system(size: 40))
                        
                    Text("ROCK")
                        .font(.system(size: 21))
                }.foregroundColor(Color.theme.accent)
                ZStack {
                    SignIn(index: $index)
                        .zIndex(Double(index))
                    Login(index: $index)
                }.padding(.top, 30)
                HStack(spacing: 15) {
                    Rectangle()
                        .fill(Color.theme.accent)
                        .frame(height: 1)
                    Text("OR")
                        .foregroundColor(Color.theme.accent)
                    Rectangle()
                        .fill(Color.theme.accent)
                        .frame(height: 1)
                }
                .padding(.horizontal, 30)
                .padding(.top, 50)
                
                HStack(spacing: 25) {
                    Button {
                        
                    } label: {
                        Image("apple")
                            .resizable()
                            .renderingMode(.original)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                    Button {
                        
                    } label: {
                        Image("google")
                            .resizable()
                            .renderingMode(.original)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                    Button {
                        
                    } label: {
                        Image("twitter")
                            .resizable()
                            .renderingMode(.original)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                }
                .padding(.top, 40)
            }
            .padding(.vertical)
        }
        .background(Color.theme.backgroundAuth.edgesIgnoringSafeArea(.all))
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
    }
}

