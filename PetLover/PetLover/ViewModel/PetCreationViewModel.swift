//
//  PetFormsViewmodel.swift
//  PetLover
//
//  Created by Izadora Montenegro on 09/04/25.
//
import Foundation
import SwiftData

@Observable
class PetCreationViewModel: ObservableObject {
    var name: String = ""
    var birthDate: Date?
    var specie: SpeciesOptions?
    var breed: String = ""
    var photo: Data?
    var castrationStatus: CastrationStatus?
    var weight: Double = 0.0
    var infos: String = ""
    var petDocuments: [PetDocument] = []
    var gender: GenderOptions?
    var reminders: [Reminder] = []

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
