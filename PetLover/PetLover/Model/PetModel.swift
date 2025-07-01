//
//  PetModel.swift
//  PetLover
//
//  Created by Izadora Montenegro on 18/03/25.
//

import SwiftData
import SwiftUI
import Foundation

@Model
class Pet: Identifiable {
    var id: UUID
    var name: String
    var birthDate: Date
    var specie: SpeciesOptions
    var breed: String
    var photo: Data?
    var castrationStatus: CastrationStatus
    var weight: Double
    var infos: String
    var petDocuments: [PetDocument]
    var gender: GenderOptions
    var reminders: [Reminder] = []
    
    init(
        name: String,
        birthDate: Date,
        specie: SpeciesOptions,
        breed: String,
        photo: Data? = nil,
        castrationStatus: CastrationStatus,
        weight: Double,
        infos: String,
        petDocuments: [PetDocument] = [],
        gender: GenderOptions,
        reminders: [Reminder] = []
    ) {
        self.id = UUID()
        self.name = name
        self.birthDate = birthDate
        self.specie = specie
        self.breed = breed
        self.photo = photo
        self.castrationStatus = castrationStatus
        self.weight = weight
        self.infos = infos
        self.petDocuments = petDocuments
        self.gender = gender
        self.reminders = reminders
    }
    
    var petAge: Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: self.birthDate, to: .now)
        return ageComponents.year ?? 0
    }
}

enum CastrationStatus: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }
    case yes, no, unknown
    
    var displayText: String {
        switch self {
        case .yes: return "Sim"
        case .no: return "Não"
        case .unknown: return "Não sei"
        }
    }
}

enum GenderOptions: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }
    case female, male
    
    var displayText: String {
        switch self {
        case .female: return "Fêmea"
        case .male: return "Macho"
        }
    }
}

enum SpeciesOptions: String, Codable, CaseIterable, Identifiable, Equatable {
    var id: Self { self }
    case dog, bird, cat
    
    var displayName: String {
        switch self {
        case .dog: return "Cachorro"
        case .bird: return "Pássaro"
        case .cat: return "Gato"
        }
    }
    
    func image() -> Image {
        switch self {
        case .dog:
            return Image("IconDog")
        case .cat:
            return Image("IconCat")
        case .bird:
            return Image("IconBird")
        }
    }
    
}
