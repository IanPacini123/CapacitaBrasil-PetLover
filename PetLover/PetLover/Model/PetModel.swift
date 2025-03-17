//
//  PetModel.swift
//  PetLover
//
//  Created by Izadora Montenegro on 17/03/25.
//

import SwiftData
import Foundation


@Model

class Pet: Identifiable {
    var name: String
    var birthDate: Date
    var species: SpeciesOptions
    var breed: String
    var petPhoto: Data?
    var castration: CastrationStatus
    var weight: Double
    var infos: String
    var petDocuments: PetDocument
    
    init(
        name: String,
        birthDate: Date,
        species: SpeciesOptions,
        breed: String,
        petPhoto: Data? = nil,
        castration: CastrationStatus,
        weight: Double,
        infos: String,
        petDocuments: PetDocument
    ) {
        self.name = name
        self.birthDate = birthDate
        self.species = species
        self.breed = breed
        self.petPhoto = petPhoto
        self.castration = castration
        self.weight = weight
        self.infos = infos
        self.petDocuments = petDocuments
    }
}

enum CastrationStatus: String, Codable, CaseIterable {
    case yes, no, unknown
    
    var displayText: String {
        switch self {
        case .yes: return "Sim"
        case .no: return "Não"
        case .unknown: return "Não sei"
        }
    }
}

enum SpeciesOptions: String, Codable, CaseIterable {
    case dog, bird, cat
    
    var displayName: String {
        switch self {
        case .dog: return "Cachorro"
        case .bird: return "Pássaro"
        case .cat: return "Gato"
        }
    }
}
