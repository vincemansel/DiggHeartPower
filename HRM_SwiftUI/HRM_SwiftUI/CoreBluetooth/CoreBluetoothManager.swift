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

  var statusText: String = ""

  override init() {
    super.init()
    centralManager = CBCentralManager(delegate: self, queue: nil)
  }
}

// MARK: -
// MARK: extension CoreBluetoothManager (Utilities)

extension CoreBluetoothManager {

  fileprivate func updateStatus(_ status: String) {
    statusText = statusText + "\n" + status
    //statusTextView.text = String(statusText)
    print(status)
  }
  
}

// MARK: -
// MARK: extension CoreBluetoothManager: CBCentralManagerDelegate

extension CoreBluetoothManager: CBCentralManagerDelegate {
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    switch central.state {
      case .unknown:
        updateStatus("central.state is .unknown")
      case .resetting:
        updateStatus("central.state is .resetting")
      case .unsupported:
        updateStatus("central.state is .unsupported")
      case .unauthorized:
        updateStatus("central.state is .unauthorized")
      case .poweredOff:
        updateStatus("central.state is .poweredOff")
      case .poweredOn:
        updateStatus("central.state is .poweredOn")
        //startScan()
      @unknown default:
        fatalError()
    }

  }
}
