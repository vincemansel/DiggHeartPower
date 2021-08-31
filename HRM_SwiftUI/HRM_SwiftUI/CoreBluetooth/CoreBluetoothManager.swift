//
//  CoreBluetoothManager.swift
//  HRM_SwiftUI
//
//  Created by Vince Mansel on 8/30/21.
//

import Combine
import CoreBluetooth

class CBInterface: ObservableObject {
  
  @Published var statusPickerOption: StatusPickerOptions = .hrm
  @Published private var manager: CoreBluetoothManager
  @Published var statusText: String = ""

  init() {
    manager = CoreBluetoothManager()
    manager.client = self
  }
  
  // MARK: Access to Manager
  
}

extension CBInterface: CoreBluetoothManagerClient {
  func updateStatus(_ statusString: String) {
    statusText = statusString
  }
}

@objc protocol CoreBluetoothManagerClient {
  func updateStatus(_ statusString: String)
  func updateBodySensorLocation(_ bodyLocation: String)
}

class CoreBluetoothManager: NSObject {
  private var centralManager: CBCentralManager!
  private var heartRatePeripheral: CBPeripheral!
  
  weak var client: CoreBluetoothManagerClient!

  private(set) var statusText: String = "Ready"
  private(set) var heartRateReceived: Int = 0
  
  private var discoveryCount = 0
  private var statusSelectionForHRM = true

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
    client.updateStatus(statusText)
    print(status)
  }
  
  fileprivate func startScan() {
    discoveryCount = 0
    
    if statusSelectionForHRM {
      centralManager.scanForPeripherals(withServices: [heartRateServiceCBUUID])
    }
    else {
      centralManager.scanForPeripherals(withServices: nil)
    }
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
        startScan()
      @unknown default:
        fatalError()
    }
  }
  
  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    
    // Track Discovery Process
    
    discoveryCount += 1
    updateStatus("\(discoveryCount): " + String(peripheral.description))
    
    if statusSelectionForHRM {
      heartRatePeripheral = peripheral
      centralManager.stopScan()
      
      centralManager.connect(heartRatePeripheral)
      heartRatePeripheral.delegate = self
    }
  }
  
  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    if let name = peripheral.name {
      updateStatus("> Connected: " + name)
    }
    else {
      updateStatus("> Connected: name = ???")
    }
    
    if statusSelectionForHRM {
      peripheral.discoverServices([heartRateServiceCBUUID])
    }
  }
}

// MARK: -
// MARK: extension CoreBluetoothManager: CBPeripheralDelegate

extension CoreBluetoothManager: CBPeripheralDelegate {
  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    updateStatus("didDiscoverServices")
    
    guard let services = peripheral.services else { return }

    for service in services {
      updateStatus(" -- :" + service.description)
      updateStatus(service.characteristics?.description ?? "characteristics are nil")

      peripheral.discoverCharacteristics(nil, for: service)
    }
  }
  
  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    updateStatus("didDiscoverCharacteristics")

    guard let characteristics = service.characteristics else { return }
    
    for characteristic in characteristics {
      updateStatus(" ---:" + characteristic.description)
      
      if characteristic.properties.contains(.read) {
        updateStatus(" ---- \(characteristic.uuid): properties contains .read")
        
        peripheral.readValue(for: characteristic)
      }
      if characteristic.properties.contains(.notify) {
        updateStatus("---- \(characteristic.uuid): properties contains .notify")
        peripheral.setNotifyValue(true, for: characteristic)
        
        peripheral.readValue(for: characteristic)

      }

      updateStatus("\n")
    }
  }
  
  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {

    /*
    #if DEBUG
    updateStatus("didUpdateValueFor: \(characteristic.uuid): ")
    
    guard let value = characteristic.value else {
      updateStatus("no value")
      return
    }
    updateStatus(value.description)
    #endif
 */
    
    switch characteristic.uuid {
      case bodySensorLocationCharacteristicCBUUID:
                
        let bodySensorLocationString = bodyLocation(from: characteristic)
        updateStatus(bodySensorLocationString)
        client.updateBodySensorLocation(bodySensorLocationString)
        
      default:
        print("Unhandled Characteristic UUID: \(characteristic.uuid)")
    }
  }
  
  private func bodyLocation(from characteristic: CBCharacteristic) -> String {
    guard let characteristicData = characteristic.value,
      let byte = characteristicData.first else { return "Error" }

    switch byte {
      case 0: return "Other"
      case 1: return "Chest"
      case 2: return "Wrist"
      case 3: return "Finger"
      case 4: return "Hand"
      case 5: return "Ear"
      case 6: return "Foot"
      default:
        return "Reserved for future use"
    }
  }
}
