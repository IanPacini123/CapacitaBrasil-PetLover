//
//  CrudOperacoes.swift
//  PetLover
//
//  Created by Izadora Montenegro on 18/03/25.
//

import SwiftData
import Foundation
import SwiftUI
import UIKit
import MobileCoreServices

func createPet(
    context: ModelContext,
    name: String,
    birthDate: Date,
    specie: SpeciesOptions,
    breed: String,
    photo: Data? = nil,
    castrationStatus: CastrationStatus,
    weight: Double,
    infos: String,
    petDocuments: [PetDocument] = [],
    gender: GenderOptions
) {
    let newPet = Pet(
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
    
    context.insert(newPet)
}

func updatePet(
    context: ModelContext,
    pet: Pet,
    name: String? = nil,
    birthDate: Date? = nil,
    specie: SpeciesOptions? = nil,
    breed: String? = nil,
    photo: Data? = nil,
    castrationStatus: CastrationStatus? = nil,
    weight: Double? = nil,
    infos: String? = nil,
    petDocuments: [PetDocument]? = nil,
    gender: GenderOptions? = nil
) {
    pet.name = name ?? pet.name
    pet.birthDate = birthDate ?? pet.birthDate
    pet.specie = specie ?? pet.specie
    pet.breed = breed ?? pet.breed
    pet.photo = photo ?? pet.photo
    pet.castrationStatus = castrationStatus ?? pet.castrationStatus
    pet.weight = weight ?? pet.weight
    pet.infos = infos ?? pet.infos
    pet.petDocuments = petDocuments ?? pet.petDocuments
    pet.gender = gender ?? pet.gender

    do {
        try context.save()
    } catch {
        print("Erro ao salvar as alterações do pet: \(error.localizedDescription)")
    }
}

func deletePet(context: ModelContext, pet: Pet) {
    context.delete(pet)
}
