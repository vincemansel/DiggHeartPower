//
//  DataComponentFormatterExtension.swift
//  HRM_SwiftUI
//
//  Created by Vince Mansel on 9/3/21.
//

import Foundation

extension DateComponentsFormatter {
  class func formatSecondsToHrMinSec(_ timeData: Float) -> String {
    let formatter = DateComponentsFormatter()
    formatter.zeroFormattingBehavior = .pad
    formatter.unitsStyle = .positional
    formatter.allowedUnits = [.hour, .minute, .second]
    
    if let timeFormattedString = formatter.string(from: Double(timeData)) {
      return timeFormattedString
    }
    
    return ""
  }
}
