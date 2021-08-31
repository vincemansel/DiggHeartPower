//
//  CoreBluetoothManager.swift
//  HRM_SwiftUI
//
//  Created by Vince Mansel on 8/30/21.
//

import Combine
import CoreBluetooth

class CoreBlueInterface: ObservableObject {
  
  @Published var statusPickerOption: StatusPickerOptions = .hrm
  @Published var heartRateReceived: Int = 0
  
  var manager = CoreBluetoothManager()
}

class CoreBluetoothManager: NSObject {
  var centralManager: CBCentralManager!

  override init() {
    super.init()
    centralManager = CBCentralManager(delegate: self, queue: nil)
  }
}

extension CoreBluetoothManager: CBCentralManagerDelegate {
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    //
  }
}
