//
//  DiggHeartPowerApp.swift
//  DiggHeartPower
//
//  Created by Vince Mansel on 8/30/21.
//

import SwiftUI

@main
struct DiggHeartPowerApp: App {
    //let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HRM_View()
                //.environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
