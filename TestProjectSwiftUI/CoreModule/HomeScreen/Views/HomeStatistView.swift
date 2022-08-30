//
//  HomeStatistView.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 19.07.2022.
//

import SwiftUI

struct HomeStatistView: View {
    @EnvironmentObject private var vm: CryptoCoreViewModel
    @Binding var showPortfolio: Bool
    
    var body: some View {
        HStack {
            ForEach(vm.statisticModel) { stat in
                StatisticView(statModel: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }.frame(width: UIScreen.main.bounds.width, alignment: showPortfolio ? .trailing : .leading)
    }
}

struct HomeStatistView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatistView(showPortfolio: .constant(false))
            .environmentObject(dev.cryptoViewModel)
    }
}
