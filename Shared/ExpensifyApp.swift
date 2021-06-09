//
//  ExpensifyApp.swift
//  Shared
//
//  Created by Jau Tung Chan on 9/6/21.
//

import SwiftUI

@main
struct ExpensifyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
