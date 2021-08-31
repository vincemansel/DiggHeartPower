//
//  CBInteface.swift
//  HRM_SwiftUI
//
//  Created by Vince Mansel on 8/31/21.
//

import Combine
import CoreBluetooth

class CBInterface: ObservableObject {
  @Published private var manager: CoreBluetoothManager
  @Published var statusText: String = ""
  @Published private(set) var bodySensorLocation:String = "-----"
  @Published private(set) var heartRateReceived: Int = 0
  
  init() {
    manager = CoreBluetoothManager()
    manager.client = self
  }
  
  // MARK: Access to Manager
  
  // MARK: - Intent(s)
  
  func changeSelection(to selection: StatusPickerOptions) {
    manager.changeSelection(to: selection)
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
