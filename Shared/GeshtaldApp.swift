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
            if #available(iOS 15.0, *) {
                ListView(geshtaldModel: GeshtaldModel(context: persistenceController.container.viewContext))
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
