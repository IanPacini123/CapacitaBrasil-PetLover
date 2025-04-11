//
//  ContentView.swift
//  PetLover
//
//  Created by Ian Pacini on 26/02/25.
//

import SwiftUI
import SwiftData

// preciso fazer os ajustes de telas, o teclado coisado, paddings, e arrumar a tela de documentos

// o fetch dos pets nao ta funcionando como deveria, nao sei exatamente o pq >( so funcionou usando a query do swiftdata



enum PetFlowDestination: Hashable {
    case petDocuments
    case petMedicalConditions
    case petProfile
    case petBasicInfo
    case home
}

struct ContentView: View {
    @Query private var pets: [Pet]
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                if pets.isEmpty {
                    Text("Nenhum pet cadastrado.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(pets, id: \.self) { pet in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Nome: \(pet.name)")
                            Text("Data de nascimento: \(pet.birthDate.formatted(date: .abbreviated, time: .omitted))")
                            Text("Espécie: \(pet.specie.rawValue)")
                            Text("Raça: \(pet.breed)")
                            Text("Castrado: \(pet.castrationStatus.rawValue)")
                            Text(String(format: "Peso: %.2f kg", pet.weight))
                            Text("Informações: \(pet.infos)")
                            Text("Sexo: \(pet.gender.rawValue)")
                            Text("Documentos: \(pet.petDocuments.count) documento(s)")
                            
                            if let photoData = pet.photo,
                               let uiImage = UIImage(data: photoData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    }
                }
                
                Button(action: {
                    path.append(PetFlowDestination.petBasicInfo)
                }) {
                    Text("Adicionar Pet")
                        .font(.title)
                }
            }
            .padding()
            .navigationDestination(for: PetFlowDestination.self) { destination in
                switch destination {
                case .petDocuments:
                    PetDocumentsView(path: $path)
                case .petMedicalConditions:
                    PetMedicalConditionsView(path: $path)
                case .petProfile:
                    PetProfileView(path: $path)
                case .petBasicInfo:
                    PetBasicInfoView(path: $path)
                case .home:
                    ContentView()
                }
            }
        }
    }
}


