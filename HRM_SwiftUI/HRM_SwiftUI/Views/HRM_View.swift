//
//  HRM_View.swift
//  HRM_SwiftUI
//
//  Created by Vince Mansel on 8/30/21.
//

import SwiftUI
import Charts

struct HRM_View: View {
  
  @ObservedObject var interface: CBInterface = CBInterface()
  
  @State private var statusPickerOption: StatusPickerOptions = .hrm
  @State private var hrZoneBinDivisor: Float = secondsPerMinute
  
  var body: some View {
    
    VStack {
      Text("DIGG Heart Rate Monitor")
        .font(.title)
        .foregroundColor(.blue)
      
      Divider()
      
      HStack {
        
        VStack {
          Text("Heart Rate")
          Text(String(interface.heartRateReceived))
            .font(.system(size: 56.0))
        }
        .padding()
        .frame( maxWidth: .infinity, idealHeight: 200)
        
        Spacer()
        
        Divider()
        
        VStack {
          Text("Body Location")
          Text(interface.bodySensorLocation)
            .font(.system(size: 50))
        }
        .padding()
        .frame( maxWidth: .infinity, idealHeight: 200)
      }
      .frame(height: 100)
      
      VStack (spacing: 0.0){
        Button(action: {
          print("Reset")
          interface.reset()
          interface.heartRateData.removeAll()
        }) {
          RoundedRectangle(cornerRadius: 10)
            .frame(width: 100, height: 60)
            .overlay(Text("Reset")
                      .foregroundColor(.white))
        }
        .padding()
        
        Text("Status")
        
        VStack (spacing: -8.0) {
          
          StatusPickerView(statusPickerOption: $statusPickerOption)
            .padding([.leading, .trailing])
            .onChange(of: statusPickerOption) {
              interface.changeSelection(to: $0)
            }
          
          MultilineTextField(text: $interface.statusText,
                             backgroundColor: UIColor.orange,
                             isEditable: false)
            .font(.headline)
            .border(Color.gray)
            .frame(height: 80)
            .background(Color.orange)
            .padding()
        }
      }
      
      VStack(spacing: -2) {
        
        Text("Charts")
        
        VStack(spacing: -30){
          ZStack {
            RoundedRectangle(cornerRadius: 15.0)
              .padding()
              .foregroundColor(.green)
            
            Text("HR vs. Time")
              .italic()
              .foregroundColor(.yellow)
            
            // TODO: - This is a basic line graph of the running heart rate.
            // No legend or numerical values
            // TODO: Note the value is a fraction resulting in FP number.
            Chart(data: interface.heartRateData.map  { $0/255.0 })
                .chartStyle(
                    LineChartStyle(.quadCurve, lineColor: .blue, lineWidth: 2)
                )
              .padding()
          }
          
          ZStack {
            RoundedRectangle(cornerRadius: 15.0)
              .padding()
              .foregroundColor(.blue)
            
            Text("HR Zones")
              .italic()
              .foregroundColor(.yellow)
            
            Chart(data: interface.heartRateZoneData.reversed().map { $0/hrZoneBinDivisor})
                .chartStyle(
                  ColumnChartStyle(column: Rectangle().foregroundColor(.red).opacity(0.7), spacing: 5)
                )
              .padding()
              .padding()
          }
          // This enables a bin to grow to hrZoneBinDivisor points before
          // resizing
          .onReceive(interface.$heartRateZoneData) {
            resizeColumnHeightIfNeeded(data: $0)
          }
        }
      }
    }
  }
  
  private func resizeColumnHeightIfNeeded(data: [Float]) {
    let maxBin = data.filter { $0 > hrZoneBinDivisor }
    if let maxZoneCount = maxBin.first, maxZoneCount >= hrZoneBinDivisor {
      hrZoneBinDivisor *= 2
    }
  }
  
  // MARK: Constants
  static let secondsPerMinute:Float = 60.0
  
}

struct HRM_View_Previews: PreviewProvider {
  static var previews: some View {
    HRM_View()
  }
}
