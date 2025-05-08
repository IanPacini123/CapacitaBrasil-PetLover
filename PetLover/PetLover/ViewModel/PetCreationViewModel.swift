//
//  PetFormsViewmodel.swift
//  PetLover
//
//  Created by Izadora Montenegro on 09/04/25.
//
import Foundation
import SwiftData

class PetCreationViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var birthDate: Date?
    @Published var specie: SpeciesOptions?
    @Published var breed: String = ""
    @Published var photo: Data?
    @Published var castrationStatus: CastrationStatus?
    @Published var weight: Double = 0.0
    @Published var infos: String = ""
    @Published var petDocuments: [PetDocument] = []
    @Published var gender: GenderOptions?
    @Published var reminders: [Reminder] = []

    func clear() {
        name = ""
        birthDate = nil
        specie = .dog
        breed = ""
        photo = nil
        castrationStatus = nil
        weight = 0.0
        infos = ""
        petDocuments = []
        gender = nil
    }

    func savePet(context: ModelContext, petViewModel: PetViewModel) {
        petViewModel.createPet(
            context: context,
            name: name,
            birthDate: birthDate ?? Date(),
            specie: specie ?? .dog,
            breed: breed,
            photo: photo,
            castrationStatus: castrationStatus ?? .unknown,
            weight: weight,
            infos: infos,
            petDocuments: petDocuments,
            gender: gender ?? .male
        )

        clear()
    }
}
