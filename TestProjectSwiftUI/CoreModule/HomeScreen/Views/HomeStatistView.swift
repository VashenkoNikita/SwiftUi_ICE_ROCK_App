//
//  HomeStatistView.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 19.07.2022.
//

import SwiftUI

struct HomeStatistView: View {
    @EnvironmentObject private var vm: CryptoCoreViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Live prices")
                .font(Font.myFont.poppins20)
                .foregroundColor(Color.theme.accent)
                .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(vm.statisticModel) { stat in
                        StatisticView(statModel: stat, widthStatView: UIScreen.main.bounds.width / 3 - 15)
                                .frame(width: UIScreen.main.bounds.width / 3 - 12)
                    }
                }
                .padding(.horizontal, 10)
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 4.5 , alignment: .leading)
        .background(Color.theme.colorOverBackground)
        .cornerRadius(32)
    }
}

struct HomeStatistView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatistView()
            .preferredColorScheme(.dark)
            .environmentObject(dev.cryptoViewModel)
    }
}
