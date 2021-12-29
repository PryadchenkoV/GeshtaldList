//
//  GeshtaldApp.swift
//  Shared
//
//  Created by Work on 11.03.2021.
//

import SwiftUI

@main
struct GeshtaldApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ListView(geshtaldModel: GeshtaldModel(context: persistenceController.container.viewContext))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
