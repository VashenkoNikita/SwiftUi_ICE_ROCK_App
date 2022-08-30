//
//  StatisticView.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 19.07.2022.
//

import SwiftUI

struct StatisticView: View {
    
    let statModel: StatisticModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(statModel.title)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryTint)
            Text(statModel.value)
                .font(.headline)
                .foregroundColor(Color.theme.accent)
            HStack(spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(Angle(degrees: (statModel.percentageChange ?? 0) >= 0 ? 0 : 180))
                Text(statModel.percentageChange?.asPercentString() ?? "")
                    .font(.caption)
                .bold()
            }
            .foregroundColor((statModel.percentageChange ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
            .opacity(statModel.percentageChange == nil ? 0 : 1.0)
        }
       
    }
}

struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatisticView(statModel: dev.statist1)
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
            StatisticView(statModel: dev.statist2)
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
            StatisticView(statModel: dev.statist3)
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}
