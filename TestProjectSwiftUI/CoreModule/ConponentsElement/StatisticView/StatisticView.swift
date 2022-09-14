//
//  StatisticView.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 19.07.2022.
//

import SwiftUI

struct StatisticView: View {
    
    let statModel: StatisticModel
    let widthStatView: CGFloat
    
    var body: some View {
        VStack {
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 0) {
                Text(statModel.value)
                    .font(Font.myFont.poppins16)
                    .foregroundColor(Color.theme.accent)
                    .padding(.bottom, 7)
                
                Text(statModel.title)
                    .font(Font.myFont.poppins12)
                    .foregroundColor(Color.theme.secondaryTint)
            }
            .padding(.leading, 15)
            .frame(width: widthStatView,alignment: .leading)
            
            Spacer()
            
            HStack(alignment: .bottom, spacing: 0) {
                Text((statModel.percentageChange ?? 0) >= 0 ? "+" : "")
                Text( statModel.percentageChange?.asPercentString() ?? "")
            }
            .font(Font.myFont.poppins13)
            .frame(width: widthStatView,alignment: .trailing)
            .padding(.bottom, 10)
            .padding(.trailing, 15)
            .foregroundColor((statModel.percentageChange ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
            .opacity(statModel.percentageChange == nil ? 0 : 1.0)
        }
        .frame(width: widthStatView, height: UIScreen.main.bounds.width / 3 - 30)
        .background(Color.theme.backgroundElements)
        .cornerRadius(16)
        .lineLimit(2)
    }
}

struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatisticView(statModel: dev.statist1, widthStatView: UIScreen.main.bounds.width / 3 - 15)
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
            StatisticView(statModel: dev.statist2, widthStatView: UIScreen.main.bounds.width / 3 - 15)
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
            StatisticView(statModel: dev.statist3, widthStatView: UIScreen.main.bounds.width / 3 - 15)
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}
