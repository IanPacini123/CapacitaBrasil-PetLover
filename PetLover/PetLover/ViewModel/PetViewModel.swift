//
//  PetViewModel.swift
//  PetLover
//
//  Created by Izadora Montenegro on 26/03/25.
//
import SwiftData
import Foundation
import SwiftUI

@Observable
class PetViewModel {
    var pets = [Pet]()
    
    static var shared: PetViewModel = .init()
    
    private init() {}
    
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
        
        do {
                try context.save()
                print("Pet salvo com sucesso!")
            } catch {
                print("Erro ao salvar o pet: \(error.localizedDescription)")
            }
        
        fetchPets(context: context)
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
        
        fetchPets(context: context)
    }
    
    func deletePet(context: ModelContext, pet: Pet) {
        context.delete(pet)
        
        fetchPets(context: context)
    }
    
    func fetchPets(context: ModelContext) {
        do {
            let descriptor = FetchDescriptor<Pet>(sortBy: [SortDescriptor(\.name)])
            pets = try context.fetch(descriptor)
        } catch {
            print("Pets não encontrados")
        }
    }
}

private struct PetTestesView: View {
    private var viewModel = PetViewModel.shared
    @Environment(\.modelContext) private var context
    
    @State private var name = ""
    @State private var birthDate = Date()
    @State private var specie: SpeciesOptions = .dog
    @State private var breed = ""
    @State private var castrationStatus: CastrationStatus = .yes
    @State private var weight = ""
    @State private var infos = ""
    @State private var gender: GenderOptions = .male
    
    var body: some View {
        VStack {
            List(viewModel.pets, id: \.id) { pet in
                HStack {
                    VStack(alignment: .leading) {
                        Text(pet.name).font(.headline)
                        Text(pet.specie.rawValue).font(.subheadline)
                    }
                    Spacer()
                    
                    Button("Atualizar") {
                        viewModel.updatePet(
                            context: context,
                            pet: pet,
                            name: name.isEmpty ? pet.name : name,
                            birthDate: birthDate,
                            specie: specie,
                            breed: breed.isEmpty ? pet.breed : breed,
                            castrationStatus: castrationStatus,
                            weight: Double(weight) ?? pet.weight,
                            infos: infos.isEmpty ? pet.infos : infos,
                            gender: gender
                        )
                    }
                    Button("Deletar") {
                        viewModel.deletePet(context: context, pet: pet)
                    }
                    
                }
            }
            
            Spacer()
            
            ScrollView {
                VStack(alignment: .leading) {
                    TextField("Nome", text: $name)
                        .padding()
                    
                    DatePicker("Data de Nascimento", selection: $birthDate, displayedComponents: .date)
                        .padding()
                    
                    Picker("Espécie", selection: $specie) {
                        ForEach(SpeciesOptions.allCases, id: \.self) { specie in
                            Text(specie.displayName).tag(specie)
                        }
                    }
                    .padding()
                    
                    TextField("Raça", text: $breed)
                        .padding()
                    
                    Picker("Status de Castração", selection: $castrationStatus) {
                        ForEach(CastrationStatus.allCases, id: \.self) { status in
                            Text(status.displayText).tag(status)
                        }
                    }
                    .padding()
                    
                    TextField("Peso (kg)", text: $weight)
                        .keyboardType(.decimalPad)
                        .padding()
                    
                    TextField("Informações", text: $infos)
                        .padding()
                    
                    Picker("Gênero", selection: $gender) {
                        ForEach(GenderOptions.allCases, id: \.self) { gender in
                            Text(gender.displayText).tag(gender)
                        }
                    }
                    .padding()
                    
                    Button("Criar Pet") {
                        viewModel.createPet(
                            context: context,
                            name: name,
                            birthDate: birthDate,
                            specie: specie,
                            breed: breed,
                            castrationStatus: castrationStatus,
                            weight: Double(weight) ?? 0.0,
                            infos: infos,
                            gender: gender
                        )
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                    
                    NavigationLink(destination: ReminderView(), label: {
                        Text("iojfuhgyd")
                    })
                }
                .padding()
            }
            
        }
        .navigationTitle("Meus Pets")
        .onAppear {
            viewModel.fetchPets(context: context)
        }
    
    }
    
}


#Preview {
    PetTestesView()
        .modelContainer(for: Pet.self, inMemory: true)
}

