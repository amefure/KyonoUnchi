//
//  UNCHILOGApp.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/24.
//

import SwiftUI

@main
struct UNCHILOGApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
