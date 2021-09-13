//
//  DiggHeartPower_Snapshot_UITests.swift
//  DiggHeartPower Snapshot UITests
//
//  Created by Vince Mansel on 9/11/21.
//

import XCTest

class DiggHeartPower_Snapshot_UITests: XCTestCase {
  
  func testExample() throws {
    // UI tests must launch the application that they test.
    let app = XCUIApplication()
    setupSnapshot(app)
    app.launch()
    
    snapshot("0Launch")
    
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    let playButton = app.buttons["playButton"]
    playButton.tap()
  
    snapshot("01Play")
    
    let stopButton = app.buttons["stopButton"]
    stopButton.tap()
    stopButton.tap()
    
    snapshot("02Stop")
    
    let deleteButton = app.buttons["Delete"]
    deleteButton.tap()
    
    app.buttons["ALL"].tap()
    
    snapshot("03SegmentAll")
  }
}
