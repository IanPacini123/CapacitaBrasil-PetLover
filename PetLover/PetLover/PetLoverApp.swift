//
//  PetLoverApp.swift
//  PetLover
//
//  Created by Ian Pacini on 26/02/25.
//

import SwiftUI
import SwiftData

@main
struct PetLoverApp: App {
    @StateObject var petCreationViewModel = PetCreationViewModel()
    var body: some Scene {
        WindowGroup {
            FluxoAdicionarPet(petCreationViewModel: petCreationViewModel)
        }
        .modelContainer(for: [Pet.self, PetDocument.self])
    }
}
