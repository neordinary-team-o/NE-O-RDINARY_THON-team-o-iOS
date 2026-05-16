//
//  ExerciseDailyStatsView.swift
//  App
//
//  Created by OpenCode on 5/15/26.
//

import SwiftUI

struct ExerciseDailyStatsView: View {
    let stats: [StatItem]

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 11) {
                ForEach(stats) { stat in
                    ExerciseStatRowView(stat: stat)
                }
            }

            Spacer(minLength: 20)

            Color.clear
                .frame(width: 84, height: 84)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 0.08, green: 0.08, blue: 0.08), in: RoundedRectangle(cornerRadius: 11))
    }
}

private struct ExerciseStatRowView: View {
    let stat: StatItem

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 10) {
            Image(systemName: stat.icon)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(stat.tintColor)
                .frame(width: 16)

            Text(stat.value)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)

            Text(stat.title)
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(.white.opacity(0.72))
        }
    }
}

private extension StatItem {
    var tintColor: Color {
        switch colorHex {
        case "C8FF00": Color(red: 0.78, green: 1.0, blue: 0.0)
        case "35C8FF": Color(red: 0.21, green: 0.78, blue: 1.0)
        case "FF2B8A": Color(red: 1.0, green: 0.17, blue: 0.54)
        default: .white
        }
    }
}

#if DEBUG
#Preview {
    ExerciseDailyStatsView(stats: StatItem.mock)
        .padding()
        .background(Color.black)
}
#endif
