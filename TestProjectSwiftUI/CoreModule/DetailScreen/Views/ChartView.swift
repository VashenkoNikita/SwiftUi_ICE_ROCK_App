//
//  ChartView.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 28.07.2022.
//

import SwiftUI

struct ChartView: View {
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let lineColor: Color
    private let startingDate: Date
    private let endingDate: Date
    @State private var percentLineGiagramAnimated: CGFloat = 0
    var showChartDetail: Bool = false
    var frameChart: CGFloat = 0
    
    init(coin: CoinModel, showChartDetail: Bool, frameChart: CGFloat) {
        
        self.showChartDetail = showChartDetail
        self.frameChart = frameChart
        
        let dataCoin = coin.sparklineIn7D?.price?.indices.filter({ index in
            return index % 2 == 1 || index == 0 || index == (coin.sparklineIn7D?.price?.count ?? 1) - 1
        }).map { index in
            coin.sparklineIn7D?.price?[index]
        }

        data = (dataCoin as? [Double]) ?? []
 
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red
        
        endingDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7*24*60*60)
    }
    var body: some View {
        VStack {
            chartView
                .frame(height: frameChart)
            if showChartDetail {
                chartDateLabels
                    .padding(.horizontal)
                    .padding(.top, 50)
            }
        }
        .font(Font.myFont.poppins12)
        .foregroundColor(Color.theme.secondaryTint)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.linear(duration: 2.0)) {
                    self.percentLineGiagramAnimated = 1.0
                }
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(coin: dev.coin, showChartDetail: true, frameChart: 200)
    }
}

extension ChartView {
    private var chartView: some View {
        GeometryReader { geometry in
            Path { path in
                for index in data.indices {
                    let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    
                    let yAxis = maxY - minY
                    
                    let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
                
            }
            .trim(from: 0, to: percentLineGiagramAnimated)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor.opacity(showChartDetail ? 0.7 : 0), radius: 10, x: 0, y: 10)
            .shadow(color: lineColor.opacity(showChartDetail ? 0.5 : 0), radius: 10, x: 0, y: 20)
            .shadow(color: lineColor.opacity(showChartDetail ? 0.2 : 0), radius: 10, x: 0, y: 30)
            .shadow(color: lineColor.opacity(showChartDetail ? 0.1 : 0), radius: 10, x: 0, y: 40)
            
        }
    }
    
    private var chartDateLabels: some View {
        HStack {
            Text(startingDate.asShortDateString())
            Spacer()
            Text(endingDate.asShortDateString())
        }
    }
}
