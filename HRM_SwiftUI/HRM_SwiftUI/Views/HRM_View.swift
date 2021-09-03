//
//  HRM_View.swift
//  HRM_SwiftUI
//
//  Created by Vince Mansel on 8/30/21.
//

import SwiftUI

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
      
      Group {
        HeartRateParameterView()
        StatusSelectionView(statusPickerOption: $statusPickerOption)
        HeartRateChartsView(hrZoneBinDivisor: $hrZoneBinDivisor)
        ControlButtonsView()
      }
      .environmentObject(interface)
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

// MARK: -
struct HeartRateParameterView: View {
  @EnvironmentObject var interface: CBInterface
  
  var body: some View {
    HStack {
      VStack {
        Text("Heart Rate")
        Text(String(interface.heartRateReceived))
          .font(.system(size: heartRateTextFontSize))
      }
      .padding()
      .frame( maxWidth: .infinity)
      
      VStack {
        Text("Body Location")
        Text(interface.bodySensorLocation)
          .font(.system(size: bodyLocationTextFontSize))
      }
      .padding()
      .frame(maxWidth: .infinity)
    }
    .frame(height: parameterFrameHeight)
  }
  
  // MARK: - Constants
  let heartRateTextFontSize: CGFloat = 56.0
  let bodyLocationTextFontSize: CGFloat = 50.0
  let parameterFrameHeight: CGFloat = 100
}

// MARK: -
struct StatusSelectionView: View {
  @EnvironmentObject var interface: CBInterface
  @Binding var statusPickerOption: StatusPickerOptions
  
  var body: some View {
    VStack (spacing: outerVStackSpacing) {
      Text("Status")
      
      VStack (spacing: innerVStackSpacing) {
        
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
  }
  
  // MARK: - Constants
  let outerVStackSpacing: CGFloat = 0.0
  let innerVStackSpacing: CGFloat = -8
}

// MARK: -
struct HeartRateChartsView: View {
  @EnvironmentObject var interface: CBInterface
  @Binding var hrZoneBinDivisor: Float

  var body: some View {
    VStack(spacing: outerVStackSpacing) {
      TimerView()
        .environmentObject(interface)
      
      VStack(spacing: innerVStackSpacing) {
        Group {
          HRvsTimeGraphView()
          HRZonesBarGraphView(hrZoneBinDivisor: $hrZoneBinDivisor)
        }
        .environmentObject(interface)
      }
    }
  }

  // MARK: - Constants
  let outerVStackSpacing: CGFloat = -2
  let innerVStackSpacing: CGFloat = -30
}

// MARK: -
struct ControlButtonsView: View {
  @EnvironmentObject var interface: CBInterface
  
  @State private var alreadyStoppedAlert: Bool = false
  
  var body: some View {
    HStack {
      Spacer()

      Button(action: {
        print("Play")
        interface.play()
      }) {
        RoundedRectangle(cornerRadius: cornerRadius)
          .frame(width: frameWidth, height: frameHeight)
          .overlay(Image(systemName: "play.fill")
                    .foregroundColor(.white))
      }
      .foregroundColor(.green)

      Spacer()

      Button(action: {
        print("Stop")
        
        if interface.alreadyStopped {
          alreadyStoppedAlert = true
        }
        else {
          interface.stop()
        }
      }) {
        RoundedRectangle(cornerRadius: cornerRadius)
          .frame(width: frameWidth, height: frameHeight)
          .overlay(Image(systemName: "stop.fill")
                    .foregroundColor(.white))
      }
      .foregroundColor(.red)
      .alert(isPresented: $alreadyStoppedAlert, content: {
        Alert(title: Text("Already Stopped"),
              message: Text("OK to Delete?"),
              primaryButton: .default(Text("Cancel")),
              secondaryButton: .destructive(Text("Delete"), action: {
                deleteWorkoutData()
              }))
      })
        
      Spacer()
    }
  }
  
  private func deleteWorkoutData() {
    interface.reset()
  }
  
  // MARK: - Constants
  let cornerRadius: CGFloat = 10.0
  let frameWidth: CGFloat = 100.0
  let frameHeight: CGFloat = 60.0
}

struct TimerView: View {
  @EnvironmentObject var interface: CBInterface
  
  var body: some View {
    Text(DateComponentsFormatter.formatSecondsToHrMinSec(Float(interface.heartRateData.count/2)))
      .font(Font.system(size: timeInZoneFontSize, design: .monospaced).monospacedDigit())
  }
  
  let timeInZoneFontSize: CGFloat = 15.0

}
