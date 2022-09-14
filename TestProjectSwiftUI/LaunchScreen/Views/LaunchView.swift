//
//  LaunchView.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 04.08.2022.
//

import SwiftUI

struct LaunchView: View {
    @State private var loadingText: [String]  = "App loading...".map{String($0)}
    @State private var isShowLoadingText: Bool = false
    var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var counter: Int = 0
    @State private var loops: Int = 0
    @Binding var showLaunchScreen: Bool
    
    var body: some View {
        ZStack {
            Color.theme.background
            .ignoresSafeArea()
          VStack {
            Image("LogoIce")
                  .resizable()
                  .frame(width: 245, height: 46)
            ZStack {
              if isShowLoadingText {
                HStack(spacing: 0) {
                    ForEach(loadingText.indices, id: \.self) { index in
                    Text(loadingText[index])
                      .foregroundColor(Color.theme.backgroundAuth)
                      .font(.headline)
                      .offset( y: counter == index ? -5 : 0)
                    
                  }
                }
                .transition(AnyTransition.scale.animation(.easeIn))
              }
            }
            .offset(y: 32)
          }
          
        }
        .onAppear {
            isShowLoadingText.toggle()
        }
        .onReceive(timer) { d in
            withAnimation(.spring()) {
                let lastIndex = loadingText.count - 1
                
                if counter == lastIndex {
                    counter = 0
                    loops += 1
                    if loops >= 2 {
                        showLaunchScreen = false
                    }
                } else {
                    counter += 1
                }
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(showLaunchScreen: .constant(true))
    }
}
