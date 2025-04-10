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
    @Published var birthDate: Date = Date()
    @Published var specie: SpeciesOptions = .dog
    @Published var breed: String = ""
    @Published var photo: Data?
    @Published var castrationStatus: CastrationStatus = .no
    @Published var weight: Double = 0.0
    @Published var infos: String = ""
    @Published var petDocuments: [PetDocument] = []
    @Published var gender: GenderOptions = .female
    @Published var reminders: [Reminder] = []
    
    func clear() {
        name = ""
        birthDate = Date()
        specie = .dog
        breed = ""
        photo = nil
        castrationStatus = .no
        weight = 0.0
        infos = ""
        petDocuments = []
        gender = .male
    }
    
    func savePet(context: ModelContext, petViewModel: PetViewModel) {
        petViewModel.createPet(
            context: context,
            name: name,
            birthDate: birthDate,
            specie: specie,
            breed: breed,
            photo: photo,
            castrationStatus: castrationStatus,
            weight: weight,
            infos: infos,
            petDocuments: petDocuments,
            gender: gender
        )
        
        clear()
    }
}
