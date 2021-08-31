//
//  StatusPickerView.swift
//  HRM_SwiftUI
//
//  Created by Vince Mansel on 8/30/21.
//

import SwiftUI

enum StatusPickerOptions: String, CaseIterable, Identifiable {
  case hrm = "HRM"
  case all = "ALL"
  
  // In this case, making the enum Identifiable does not pay off in the
  // associated form picker, because without the id parameter in the ForEach
  // constructor, the selected item does not show in the form, or appears
  // to maintain the selection with a click mark ;)
  var id: String {
    return self.rawValue
  }
}

struct StatusPickerView: View {
  
  @Binding var statusPickerOption: StatusPickerOptions
  
  var body: some View {
    Picker(selection: $statusPickerOption,
           label: Text("Picker Options"), content: {
            ForEach(StatusPickerOptions.allCases, id:\.self) { option in
              Text(option.rawValue)
            }
           }).pickerStyle(SegmentedPickerStyle())
  }
}

//struct StatusPickerView_Previews: PreviewProvider {
//    static var previews: some View {
//        StatusPickerView()
//    }
//}
