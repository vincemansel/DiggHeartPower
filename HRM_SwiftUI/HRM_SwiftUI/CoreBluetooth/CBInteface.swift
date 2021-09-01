//
//  CBInteface.swift
//  HRM_SwiftUI
//
//  Created by Vince Mansel on 8/31/21.
//

import Combine
import CoreBluetooth

let bodySensorLocationDefault = "-----"
let heartRateReceivedDefault = 0

class CBInterface: ObservableObject {
  @Published private var manager: CoreBluetoothManager
  @Published var statusText: String = ""
  @Published private(set) var bodySensorLocation:String = bodySensorLocationDefault
  @Published private(set) var heartRateReceived: Int = heartRateReceivedDefault
  
  @Published var heartRateData: [Float] = []
  @Published var heartRateZoneData: [Float] = [1.0,1.0,1.0,1.0,1.0]
  
  var alreadyStopped: Bool {
    get {
      manager.managerState == .stopped
    }
  }

  init() {
    manager = CoreBluetoothManager()
    manager.client = self
  }
  
  // MARK: Access to Manager
  
  // MARK: - Intent(s)
  
  func changeSelection(to selection: StatusPickerOptions) {
    manager.changeSelection(to: selection)
  }
  
  func play() {
    manager.play()
  }
  
  func pause() {
    manager.pause()
  }
  
  func stop() {
    manager.stop()
  }
  
  func reset() {
    manager.reset()
    resetAllData()
  }
  
  private func resetAllData() {
    heartRateData = []
    heartRateZoneData = [1.0,1.0,1.0,1.0,1.0]
  }
}

extension CBInterface: CoreBluetoothManagerClient {
  func updateStatus(_ statusString: String) {
    statusText = statusString
  }
  
  func onBodySensorLocationReceived(_ bodyLocation: String) {
    bodySensorLocation = bodyLocation
  }
  
  func onHeartRateReceived(_ bpm: Int) {
    heartRateReceived = bpm
    heartRateData.append(Float(bpm))
    heartRateZoneCalculator(bpm: bpm)
  }
  
  // NOTE: Zone indexes are flipped: Bin 0 = Zone 5, reverse in UI
  var zone: [(low: Int, high: Int)] {
    [(0,103), (104,125), (126,142), (143,159), (160,255)]
    // TESTING: [(0,50), (51,65), (66,80), (81,95), (96,255)]
  }
  
  private func heartRateZoneCalculator(bpm: Int) {
    guard bpm > 0 else { return }
    guard heartRateZoneBin(0, bpm: bpm) else { return }
    guard heartRateZoneBin(1, bpm: bpm) else { return }
    guard heartRateZoneBin(2, bpm: bpm) else { return }
    guard heartRateZoneBin(3, bpm: bpm) else { return }
    guard heartRateZoneBin(4, bpm: bpm) else { return }
    
    // Should never reach here unless HR goes beyond 255
    #if DEBUG
    fatalError()
    #endif
  }
  
  private func heartRateZoneBin(_ bin: Int, bpm: Int) -> Bool {
    if bpm >= zone[bin].low && bpm <= zone[bin].high {
      heartRateZoneData[bin] = heartRateZoneData[bin] + 1
      return false
    }
    return true
  }
}
