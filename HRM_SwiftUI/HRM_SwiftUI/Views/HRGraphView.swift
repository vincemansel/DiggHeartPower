//
//  HRGraphView.swift
//  HRM_SwiftUI
//
//  Created by Vince Mansel on 8/31/21.
//

import SwiftUI
import Charts

// Reference: https://github.com/spacenation/swiftui-charts

fileprivate let backgroundCornerRadius: CGFloat = 5.0

struct HRZonesBarGraphView: View {
  @EnvironmentObject var interface: CBInterface
  @Binding var hrZoneBinDivisor: Float

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: backgroundCornerRadius)
        .padding()
        .foregroundColor(.blue)
      
      Text("HR Zones")
        .italic()
        .foregroundColor(.yellow)
      
      Chart(data: interface.heartRateZoneData.reversed().map { $0/hrZoneBinDivisor})
        .chartStyle(
          ColumnChartStyle(column: Rectangle().foregroundColor(.red).opacity(columnChartBinOpacity),
                           spacing: columnChartBinSpacing)
        )
        .padding()
        .padding()
      
      HStack (spacing: timeInZoneHorizontalSpacing) {
        ForEach(interface.heartRateZoneData, id: \.self) { zoneData in
          Text(timeInZone(zoneData))
            .font(Font.system(size: timeInZoneFontSize, design: .monospaced).monospacedDigit())
        }
      }
      .offset(x: 0, y: timeInZoneYOffset)
      
    }
    // This enables a bin to grow to hrZoneBinDivisor points before resizing
    .onReceive(interface.$heartRateZoneData) {
      resizeColumnHeightIfNeeded(data: $0)
    }
  }
  
  private func resizeColumnHeightIfNeeded(data: [Float]) {
    let maxBin = data.filter { $0 > hrZoneBinDivisor }
    if let maxZoneCount = maxBin.first, maxZoneCount >= hrZoneBinDivisor {
      hrZoneBinDivisor *= 2
    }
  }
  
  private func timeInZone(_ zoneData: Float) -> String {
    // convert float x.y to 0:00:00 format
    // TODO: Assume hrTicks per second - need timer (seconds)
    let adjustedZoneData = (zoneData - 1.0)/2.0
    return DateComponentsFormatter.formatSecondsToHrMinSec(adjustedZoneData)
  }
  
  // MARK: - Constants
  let columnChartBinOpacity: Double = 0.7
  let columnChartBinSpacing: CGFloat = 5.0
  let timeInZoneHorizontalSpacing: CGFloat = 13.5
  let timeInZoneFontSize: CGFloat = 10.0
  let timeInZoneYOffset: CGFloat = 40.0
}

struct HRvsTimeGraphView: View {
  @EnvironmentObject var interface: CBInterface

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: backgroundCornerRadius)
        .padding()
        .foregroundColor(.green)
      
      Text("HR vs. Time")
        .italic()
        .foregroundColor(.yellow)
      
      // TODO: - This is a basic line graph of the running heart rate.
      // No legend or numerical values
      // TODO: Note the value is a fraction resulting in FP number.
      Chart(data: interface.heartRateData.map  { $0/maxHeartRate })
        .chartStyle(
          LineChartStyle(.quadCurve,
                         lineColor: .blue,
                         lineWidth: lineChartLineWidth)
        )
        .padding()
    }
  }
  
  // MARK: - Constants
  
  let maxHeartRate: Float = 255.0
  let lineChartLineWidth:CGFloat = 2
}

