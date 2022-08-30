//
//  DetailView.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 27.07.2022.
//

import SwiftUI

struct DetailLoadView: View {
    @Binding var coin: CoinModel?
    
    
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    @StateObject private var vm: DetailViewModel
    @State private var isReadMore: Bool = false
    
    private var colomns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    var body: some View {
        ScrollView {
            VStack {
                ChartView(coin: vm.coin)
                    .padding(.vertical)
                VStack(spacing: 20) {
                    descriptionTitle
                    Divider()
                        .background(Color.theme.accent)
                    descriptionCoin
                    
                    overviewTitle
                    Divider()
                        .background(Color.theme.accent)
                    overviewGrid
                    
                    additionalTitle
                    Divider()
                        .background(Color.theme.accent)
                    additionalGrid
                    webSiteLink
                }
                .padding()
            }
        }
        .navigationTitle(vm.coin.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                toolBarTrailingItems
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: dev.coin)
                .preferredColorScheme(.dark)
        }
    }
}


extension DetailView {
    private var descriptionTitle: some View {
        Text("Description")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var descriptionCoin: some View {
        ZStack {
            if let coinDescription = vm.coinDescription, !coinDescription.isEmpty {
                VStack(alignment: .leading) {
                    Text(coinDescription)
                        .lineLimit(isReadMore ? .none : 4)
                        .font(.callout)
                    Button {
                        withAnimation(.easeInOut) {
                            isReadMore.toggle()
                        }
                    } label: {
                        Text(isReadMore ? "Hide text" : "Read more...")
                            .font(.caption)
                            .bold()
                            .foregroundColor(Color.blue)
                            .padding(.vertical, 1)
                    }
                }
                .foregroundColor(Color.theme.secondaryTint)
                
            }
        }
    }
    
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    private var additionalTitle: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    private var overviewGrid: some View {
        LazyVGrid(columns: colomns,
                  alignment: .leading,
                  spacing: 30,
                  pinnedViews: []) {
            ForEach(vm.overviewStat) { stat in
                StatisticView(statModel: stat)
            }
        }
    }
    private var additionalGrid: some View {
        LazyVGrid(columns: colomns,
                  alignment: .leading,
                  spacing: 30,
                  pinnedViews: []) {
            ForEach(vm.additionalStat) { stat in
                StatisticView(statModel: stat)
            }
        }
    }
    private var toolBarTrailingItems: some View {
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.secondaryTint)
            CryptoImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
        }

    }
    
    private var webSiteLink: some View {
        ZStack {
            if let websiteURLString = vm.websiteURL, let url = URL(string: websiteURLString) {
                Link("Website", destination: url)
                    .font(.headline)
                    .accentColor(Color.blue)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
}
