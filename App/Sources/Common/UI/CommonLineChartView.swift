//
//  CommonLineChartView.swift
//  App
//
//  Created by OpenCode on 5/16/26.
//

import SwiftUI

public struct CommonLineChartData: Equatable, Hashable {
    public let title: String
    public let subtitle: String
    public let maxValue: Double
    public let yAxisValues: [Double]
    public let entries: [CommonLineChartEntry]

    public init(
        title: String,
        subtitle: String,
        maxValue: Double,
        yAxisValues: [Double],
        entries: [CommonLineChartEntry]
    ) {
        self.title = title
        self.subtitle = subtitle
        self.maxValue = maxValue
        self.yAxisValues = yAxisValues
        self.entries = entries
    }
}

public struct CommonLineChartEntry: Equatable, Hashable, Identifiable {
    public let id: Int
    public let month: String
    public let value: Double

    public init(id: Int, month: String, value: Double) {
        self.id = id
        self.month = month
        self.value = value
    }
}

public struct CommonLineChartView: View {
    let chartData: CommonLineChartData

    public init(chartData: CommonLineChartData) {
        self.chartData = chartData
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: CommonLineChartStyle.contentSpacing) {
            titleArea
            CommonLineChartPlotView(chartData: chartData)
                .frame(height: CommonLineChartStyle.plotHeight)
        }
        .padding(.horizontal, CommonLineChartStyle.cardHorizontalPadding)
        .padding(.vertical, CommonLineChartStyle.cardVerticalPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            CommonLineChartStyle.cardBackground,
            in: RoundedRectangle(cornerRadius: CommonLineChartStyle.cardRadius)
        )
    }

    private var titleArea: some View {
        VStack(alignment: .leading, spacing: CommonLineChartStyle.titleSpacing) {
            Text(chartData.title)
                .font(.system(size: CommonLineChartStyle.titleFontSize, weight: .bold))
                .foregroundStyle(.white)

            Text(chartData.subtitle)
                .font(.system(size: CommonLineChartStyle.subtitleFontSize, weight: .medium))
                .foregroundStyle(.white.opacity(CommonLineChartStyle.subtitleOpacity))
        }
    }
}

private struct CommonLineChartPlotView: View {
    let chartData: CommonLineChartData

    var body: some View {
        GeometryReader { proxy in
            let layout = CommonLineChartPlotLayout(size: proxy.size)

            ZStack {
                gridLines(layout: layout)
                yAxisLabels(layout: layout)
                if chartData.entries.isEmpty {
                    emptyState(layout: layout)
                } else {
                    xAxisLabels(layout: layout)
                    trendLine(layout: layout)
                    pointMarkers(layout: layout)
                }
            }
        }
    }

    private func gridLines(layout: CommonLineChartPlotLayout) -> some View {
        Path { path in
            for value in chartData.yAxisValues {
                let yPosition = layout.yPosition(for: value, maxValue: chartData.maxValue)
                path.move(to: CGPoint(x: layout.plotFrame.minX, y: yPosition))
                path.addLine(to: CGPoint(x: layout.plotFrame.maxX, y: yPosition))
            }

            for index in chartData.entries.indices {
                let xPosition = layout.xPosition(for: index, count: chartData.entries.count)
                path.move(to: CGPoint(x: xPosition, y: layout.plotFrame.minY))
                path.addLine(to: CGPoint(x: xPosition, y: layout.plotFrame.maxY))
            }
        }
        .stroke(
            CommonLineChartStyle.gridLine,
            style: StrokeStyle(lineWidth: CommonLineChartStyle.gridLineWidth)
        )
    }

    private func yAxisLabels(layout: CommonLineChartPlotLayout) -> some View {
        ForEach(Array(chartData.yAxisValues.enumerated()), id: \.offset) { _, value in
            Text(value.formatted(.number.precision(.fractionLength(0))))
                .font(.system(size: CommonLineChartStyle.axisLabelFontSize, weight: .medium))
                .foregroundStyle(.white.opacity(CommonLineChartStyle.yAxisLabelOpacity))
                .frame(width: layout.yAxisLabelWidth, alignment: .trailing)
                .position(
                    x: layout.yAxisLabelWidth / 2,
                    y: layout.yPosition(for: value, maxValue: chartData.maxValue)
                )
        }
    }

    private func xAxisLabels(layout: CommonLineChartPlotLayout) -> some View {
        ForEach(Array(chartData.entries.enumerated()), id: \.element.id) { index, entry in
            Text(entry.month)
                .font(.system(size: CommonLineChartStyle.axisLabelFontSize, weight: .medium))
                .foregroundStyle(.white.opacity(CommonLineChartStyle.xAxisLabelOpacity))
                .position(
                    x: layout.xPosition(for: index, count: chartData.entries.count),
                    y: layout.xAxisLabelYPosition
                )
        }
    }

    private func emptyState(layout: CommonLineChartPlotLayout) -> some View {
        Text("No chart data available")
            .font(.system(size: CommonLineChartStyle.emptyStateFontSize, weight: .medium))
            .foregroundStyle(.white.opacity(CommonLineChartStyle.emptyStateOpacity))
            .frame(width: layout.plotFrame.width, height: layout.plotFrame.height)
            .position(x: layout.plotFrame.midX, y: layout.plotFrame.midY)
    }

    private func trendLine(layout: CommonLineChartPlotLayout) -> some View {
        Group {
            if chartData.entries.count > 1 {
                Path { path in
                    for (index, entry) in chartData.entries.enumerated() {
                        let point = CGPoint(
                            x: layout.xPosition(for: index, count: chartData.entries.count),
                            y: layout.yPosition(for: entry.value, maxValue: chartData.maxValue)
                        )

                        if index == 0 {
                            path.move(to: point)
                        } else {
                            path.addLine(to: point)
                        }
                    }
                }
                .stroke(
                    CommonLineChartStyle.trendLine,
                    style: StrokeStyle(
                        lineWidth: CommonLineChartStyle.trendLineWidth,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
                .shadow(
                    color: CommonLineChartStyle.trendLine.opacity(CommonLineChartStyle.trendLineShadowOpacity),
                    radius: CommonLineChartStyle.trendLineShadowRadius,
                    x: 0,
                    y: CommonLineChartStyle.trendLineShadowOffset
                )
            }
        }
    }

    private func pointMarkers(layout: CommonLineChartPlotLayout) -> some View {
        ForEach(Array(chartData.entries.enumerated()), id: \.element.id) { index, entry in
            Circle()
                .fill(CommonLineChartStyle.trendLine)
                .frame(
                    width: CommonLineChartStyle.pointMarkerSize,
                    height: CommonLineChartStyle.pointMarkerSize
                )
                .overlay {
                    Circle()
                        .stroke(CommonLineChartStyle.cardBackground, lineWidth: CommonLineChartStyle.pointMarkerStrokeWidth)
                }
                .position(
                    x: layout.xPosition(for: index, count: chartData.entries.count),
                    y: layout.yPosition(for: entry.value, maxValue: chartData.maxValue)
                )
        }
    }
}

private struct CommonLineChartPlotLayout {
    let size: CGSize

    let yAxisLabelWidth: CGFloat = CommonLineChartStyle.yAxisLabelWidth
    let labelGap: CGFloat = CommonLineChartStyle.axisLabelGap
    let topInset: CGFloat = CommonLineChartStyle.plotTopInset
    let bottomInset: CGFloat = CommonLineChartStyle.plotBottomInset
    let trailingInset: CGFloat = CommonLineChartStyle.plotTrailingInset

    var plotFrame: CGRect {
        CGRect(
            x: yAxisLabelWidth + labelGap,
            y: topInset,
            width: max(0, size.width - yAxisLabelWidth - labelGap - trailingInset),
            height: max(0, size.height - topInset - bottomInset)
        )
    }

    var xAxisLabelYPosition: CGFloat {
        plotFrame.maxY + CommonLineChartStyle.xAxisLabelGap
    }

    func xPosition(for index: Int, count: Int) -> CGFloat {
        guard count > 1 else { return plotFrame.midX }
        return plotFrame.minX + (plotFrame.width * CGFloat(index) / CGFloat(count - 1))
    }

    func yPosition(for value: Double, maxValue: Double) -> CGFloat {
        guard maxValue > 0 else { return plotFrame.maxY }
        let normalizedValue = min(max(value / maxValue, 0), 1)
        return plotFrame.maxY - (plotFrame.height * CGFloat(normalizedValue))
    }
}

private enum CommonLineChartStyle {
    static let cardBackground = Color(red: 0.08, green: 0.08, blue: 0.08)
    static let gridLine = Color.white.opacity(0.1)
    static let trendLine = Color(red: 0.21, green: 0.78, blue: 1.0)

    static let cardRadius: CGFloat = 11
    static let contentSpacing: CGFloat = 16
    static let cardHorizontalPadding: CGFloat = 16
    static let cardVerticalPadding: CGFloat = 16
    static let previewHorizontalPadding: CGFloat = 14
    static let titleSpacing: CGFloat = 4
    static let plotHeight: CGFloat = 190
    static let yAxisLabelWidth: CGFloat = 28
    static let axisLabelGap: CGFloat = 8
    static let plotTopInset: CGFloat = 8
    static let plotBottomInset: CGFloat = 28
    static let plotTrailingInset: CGFloat = 4
    static let xAxisLabelGap: CGFloat = 16
    static let gridLineWidth: CGFloat = 1
    static let trendLineWidth: CGFloat = 5
    static let trendLineShadowRadius: CGFloat = 8
    static let trendLineShadowOffset: CGFloat = 4
    static let pointMarkerSize: CGFloat = 10
    static let pointMarkerStrokeWidth: CGFloat = 2

    static let titleFontSize: CGFloat = 20
    static let subtitleFontSize: CGFloat = 12
    static let axisLabelFontSize: CGFloat = 10
    static let emptyStateFontSize: CGFloat = 12

    static let subtitleOpacity = 0.62
    static let yAxisLabelOpacity = 0.48
    static let xAxisLabelOpacity = 0.55
    static let emptyStateOpacity = 0.52
    static let trendLineShadowOpacity = 0.36
}

#if DEBUG
#Preview("Default") {
    CommonLineChartView(chartData: .previewTrend)
        .padding(.horizontal, CommonLineChartStyle.previewHorizontalPadding)
        .padding(.vertical, CommonLineChartStyle.cardVerticalPadding)
        .background(Color.black)
}

#Preview("Empty") {
    CommonLineChartView(chartData: .previewEmpty)
        .padding(.horizontal, CommonLineChartStyle.previewHorizontalPadding)
        .padding(.vertical, CommonLineChartStyle.cardVerticalPadding)
        .background(Color.black)
}

#Preview("Single Entry") {
    CommonLineChartView(chartData: .previewSingleEntry)
        .padding(.horizontal, CommonLineChartStyle.previewHorizontalPadding)
        .padding(.vertical, CommonLineChartStyle.cardVerticalPadding)
        .background(Color.black)
}

private extension CommonLineChartData {
    static let previewTrend = CommonLineChartData(
        title: "Sample Trend",
        subtitle: "Reusable line chart preview",
        maxValue: 150,
        yAxisValues: [0, 50, 100, 150],
        entries: [
            CommonLineChartEntry(id: 0, month: "Jan", value: 22),
            CommonLineChartEntry(id: 1, month: "Feb", value: 44),
            CommonLineChartEntry(id: 2, month: "Mar", value: 38),
            CommonLineChartEntry(id: 3, month: "Apr", value: 76),
            CommonLineChartEntry(id: 4, month: "May", value: 68),
            CommonLineChartEntry(id: 5, month: "Jun", value: 96),
            CommonLineChartEntry(id: 6, month: "Jul", value: 118),
            CommonLineChartEntry(id: 7, month: "Aug", value: 104),
            CommonLineChartEntry(id: 8, month: "Sep", value: 132)
        ]
    )

    static let previewEmpty = CommonLineChartData(
        title: "Sample Trend",
        subtitle: "Reusable line chart preview",
        maxValue: 150,
        yAxisValues: [0, 50, 100, 150],
        entries: []
    )

    static let previewSingleEntry = CommonLineChartData(
        title: "Sample Trend",
        subtitle: "Reusable line chart preview",
        maxValue: 150,
        yAxisValues: [0, 50, 100, 150],
        entries: [
            CommonLineChartEntry(id: 0, month: "Jan", value: 72)
        ]
    )
}
#endif
