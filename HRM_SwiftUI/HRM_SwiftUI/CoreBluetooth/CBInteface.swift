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
  
  init() {
    manager = CoreBluetoothManager()
    manager.client = self
  }
  
  // MARK: Access to Manager
  
  // MARK: - Intent(s)
  
  func changeSelection(to selection: StatusPickerOptions) {
    manager.changeSelection(to: selection)
  }
  
  func reset() {
    manager.reset()
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
  }
}
