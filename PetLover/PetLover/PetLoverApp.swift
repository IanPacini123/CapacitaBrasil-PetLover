//
//  PetLoverApp.swift
//  PetLover
//
//  Created by Ian Pacini on 26/02/25.
//

import SwiftUI

@main
struct PetLoverApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Pet.self, PetDocument.self])
    }
}
