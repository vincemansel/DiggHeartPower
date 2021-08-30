//
//  HRM_SwiftUIApp.swift
//  HRM_SwiftUI
//
//  Created by Vince Mansel on 8/30/21.
//

import SwiftUI

@main
struct HRM_SwiftUIApp: App {
    //let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HRM_View()
                //.environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
