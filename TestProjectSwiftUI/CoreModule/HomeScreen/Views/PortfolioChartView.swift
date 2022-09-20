//
//  PortfolioChartView.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 02.09.2022.
//

import SwiftUI

struct PortfolioChartView: View {
    
    @EnvironmentObject private var vm: CryptoCoreViewModel
    @State private var totalPortfolioPrice: Double = 0
    
    let values: [Double]
    var colors: [Color]
    
    var widthFraction: CGFloat
    var innerRadiusFraction: CGFloat
    
    @State private var activeIndex: Int = -1
    
    init(values:[Double], colors: [Color] = [Color.theme.red, Color.theme.green, Color.theme.backgroundAuth, Color.orange, Color.yellow, Color.blue, Color.theme.tintColor], widthFraction: CGFloat = 0.75, innerRadiusFraction: CGFloat = 0.9){
        self.values = values
        
        self.colors = colors
        self.widthFraction = widthFraction
        self.innerRadiusFraction = innerRadiusFraction
    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                VStack{
                    ZStack{
                        ForEach(Array(slices.enumerated()), id:
                                    \.0){ index, slice in
                            PortfolioStatisticSlice(portfolioSliceData: slice)
                                .scaleEffect(self.activeIndex == index ? 1.03 : 1)
                                .animation(Animation.spring())
                        }
                                    .frame(width: widthFraction * geometry.size.width, height: widthFraction * geometry.size.width)
                                    .gesture(
                                        DragGesture(minimumDistance: 0)
                                            .onChanged { value in
                                                let radius = 0.5 * widthFraction * geometry.size.width
                                                let diff = CGPoint(x: value.location.x - radius, y: radius - value.location.y)
                                                let dist = pow(pow(diff.x, 2.0) + pow(diff.y, 2.0), 0.5)
                                                if (dist > radius || dist < radius * innerRadiusFraction) {
                                                    self.activeIndex = -1
                                                    return
                                                }
                                                var radians = Double(atan2(diff.x, diff.y))
                                                if (radians < 0) {
                                                    radians = 2 * Double.pi + radians
                                                }
                                                
                                                for (i, slice) in slices.enumerated() {
                                                    if (radians < slice.endAngle.radians) {
                                                        self.activeIndex = i
                                                        break
                                                    }
                                                }
                                            }
                                            .onEnded { value in
                                                self.activeIndex = -1
                                            }
                                    )
                        
                        Circle()
                            .fill(Color.theme.colorOverBackground)
                            .frame(width: widthFraction * geometry.size.width * innerRadiusFraction , height: widthFraction * geometry.size.width * innerRadiusFraction )
                        totalPriceInfo
                        
                    }
                    Spacer()
                    scrollChartView
                        .padding(.top, 12)
                }
            }
            
            .padding(.all, 16)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
            .background(Color.theme.colorOverBackground)
            .cornerRadius(32)
        }
    }
}

struct PortfolioChartView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioChartView(values: [1300, 500, 300, 600, 500])
            .environmentObject(dev.cryptoViewModel)
    }
}

extension PortfolioChartView {
    
    private var totalPriceInfo: some View {
        VStack {
            Text(vm.statisticModel.last?.value ?? "")
                .foregroundColor(Color.theme.accent)
                .font(Font.myFont.poppins28)
                .padding(.all, 4)
            
            HStack(alignment: .bottom, spacing: 0) {
                Text((vm.statisticModel.last?.percentageChange ?? 0) >= 0 ? "+" : "")
                Text( vm.statisticModel.last?.percentageChange?.asPercentString() ?? "")
            }
            .font(Font.myFont.poppins16)
            .foregroundColor((vm.statisticModel.last?.percentageChange ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
        }
    }
    
    private var scrollChartView: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack {
                ForEach(Array(zip(vm.cryptoCurrencyPortfolio.indices, vm.cryptoCurrencyPortfolio.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue }))) , id: \.1) { index, elememt in
                    HStack {
                        Text("●")
                            .font(Font.myFont.poppins20)
                        Spacer(minLength: 6)
                        Text(returnPercentValueToTotal(coin: elememt))
                            .font(Font.myFont.poppins12)
                    }
                    .frame(height: UIScreen.main.bounds.height / 20)
                    .padding(.vertical, 1)
                    .padding(.horizontal, 8)
                    .foregroundColor(
                        index <= 6 ? colors[index] : Color.theme.tintColor
                    )
                    .background(index <= 6 ? colors[index].opacity(0.2) : Color.theme.tintColor.opacity(0.2))
                    .cornerRadius(8)
                }
            }
        }
        .frame(height: UIScreen.main.bounds.height / 20)
    }
    
    private var slices: [PortfolioSliceData] {
        let sum = values.reduce(0, +)
        var endDeg: Double = 0
        var tempSlices: [PortfolioSliceData] = []
        
        for (i, value) in values.enumerated() {
            let degrees: Double = value * 360 / sum
            tempSlices.append(PortfolioSliceData(startAngle: Angle(degrees: endDeg), endAngle: Angle(degrees: endDeg + degrees), color: colors[i]))
            endDeg += degrees
        }
        return tempSlices
    }
    
    private func ugradePortfolioTotalPrice(portfolioCoin: [CoinModel]) -> Double {
        let portfolioValue =
        portfolioCoin
            .map({$0.currentHoldingsValue})
            .reduce(0, +)
        
        return portfolioValue
    }
    
    private func returnPercentValueToTotal(coin: CoinModel) -> String {
        return "\(coin.symbol.uppercased()) (\(((coin.currentHoldingsValue / ugradePortfolioTotalPrice(portfolioCoin: vm.cryptoCurrencyPortfolio)) * 100).asPercentString()))"
    }
}
