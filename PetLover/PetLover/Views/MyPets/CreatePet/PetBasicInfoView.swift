//
//  PetInfosView.swift
//  PetLover
//
//  Created by Izadora Montenegro on 07/04/25.
//

import SwiftUI
import Foundation
import SwiftData

struct PetBasicInfoView: View {
    @ObservedObject var petCreationViewModel: PetCreationViewModel
    @Environment(\.dismiss) var dismiss
    @Binding var path: NavigationPath
    
    @State private var showGenderPicker: Bool = false
    @State private var showDatePicker: Bool  = false
    @State private var buttonPressed: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                PetFormHeader(title: "Informações básicas", text: "Insira as informações primárias do seu pet!", totalPages: 4, currentPage: 1)
                
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nome do pet")
                            .appFontDarkerGrotesque(darkness: .ExtraBold, size: 19)
                            .padding(.leading)
                        SinglelineTextField(text: $petCreationViewModel.name, buttonPressed: $buttonPressed, label: "Insira o nome do seu animalzinho")
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Data de nascimento")
                            .appFontDarkerGrotesque(darkness: .ExtraBold, size: 19)
                            .padding(.leading)
                        SeletorInput(label: petCreationViewModel.birthDate != nil ? formattedDate(petCreationViewModel.birthDate!) : "Selecione qual a data de nascimento", action: {
                            showDatePicker = true
                        })
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Gênero")
                            .appFontDarkerGrotesque(darkness: .ExtraBold, size: 19)
                            .padding(.leading)
                        SeletorInput(label: (petCreationViewModel.gender != nil) ? petCreationViewModel.gender!.displayText : "Qual o gênero do seu pet?", action: {
                            showGenderPicker = true
                        })
                        
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Espécie")
                            .appFontDarkerGrotesque(darkness: .ExtraBold, size: 19)
                        
                        HStack {
                            ForEach(SpeciesOptions.allCases) { species in
                                SpeciesButton(species: species, selectedSpecies: $petCreationViewModel.specie)
                            }
                        }
                    }
                    .padding(.leading)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Raça")
                            .appFontDarkerGrotesque(darkness: .ExtraBold, size: 19)
                            .padding(.leading)
                        SinglelineTextField(text: $petCreationViewModel.breed, buttonPressed: $buttonPressed, label: "Qual a raça do seu pet?")
                    }
                }
            }
            .padding(.top, 40)
            .sheet(isPresented: $showGenderPicker) {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Selecione o gênero:")
                        .appFontDarkerGrotesque(darkness: .ExtraBold, size: 20)
                    
                    Button(action: {
                        petCreationViewModel.gender = .female
                        showGenderPicker = false
                    }, label: {
                        Text("Fêmea")
                            .foregroundStyle(petCreationViewModel.gender == .female ? .white : .black)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 130)
                            .background {
                                if petCreationViewModel.gender != .female {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(lineWidth: 2)
                                        .foregroundStyle(.black)
                                } else {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(Color.AppColors.secondary40Blue)
                                }
                            }
                    })
                    
                    Button(action: {
                        petCreationViewModel.gender = .male
                        showGenderPicker = false
                    }, label: {
                        Text("Macho")
                            .foregroundStyle(petCreationViewModel.gender == .male ? .white : .black)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 130)
                            .background {
                                if petCreationViewModel.gender != .male {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(lineWidth: 2)
                                        .foregroundStyle(.black)
                                } else {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(Color.AppColors.secondary40Blue)
                                }
                            }
                    })
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    Color.AppColors.nearNeutralLightLightGray.ignoresSafeArea()
                )
                .presentationDetents([.fraction(0.3)])
            }
            .sheet(isPresented: $showDatePicker) {
                VStack {
                    DatePicker(
                        "Selecione a data de nascimento",
                        selection: Binding(
                            get: { petCreationViewModel.birthDate ?? Date() },
                            set: { petCreationViewModel.birthDate = $0 }
                        ),
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.graphical)
                    .padding()
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    Color.AppColors.nearNeutralLightLightGray.ignoresSafeArea()
                )
                .presentationDetents([.fraction(0.60)])
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .background(
            Color.AppColors.nearNeutralLightLightGray.ignoresSafeArea()
        )
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                   dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.black)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("Adicionar")
                    .appFontDarkerGrotesque(darkness: .Black, size: 32)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    path.append(PetFlowDestination.petProfile)
                }) {
                   Text("Avançar")
                        .appFontDarkerGrotesque(darkness: .SemiBold, size: 17)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}



// testes de view e navegação que depois serão passados pra home

enum PetFlowDestination: Hashable {
    case petDocuments
    case petMedicalConditions
    case petProfile
    case petBasicInfo
}

struct FluxoAdicionarPet: View {
    @Query private var pets: [Pet]
    @State var path = NavigationPath()
    @ObservedObject var petCreationViewModel: PetCreationViewModel
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack {
                    Button(action: {
                        path.append(PetFlowDestination.petBasicInfo)
                    }) {
                        Text("Adicionar Pet")
                            .font(.title)
                            .padding()
                            .background(Color.AppColors.primary30Beige)
                    }
                    
                    if pets.isEmpty {
                        Text("Nenhum pet cadastrado.")
                            .padding()
                    } else {
                        ForEach(pets, id: \.self) { pet in
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(pet.name)
                                    Text("Data de nascimento: \(pet.birthDate.formatted(date: .abbreviated, time: .omitted))")
                                    Text("Espécie: \(pet.specie.rawValue)")
                                    Text("Raça: \(pet.breed)")
                                    Text("Castrado: \(pet.castrationStatus.rawValue)")
                                    Text(String(format: "Peso: %.2f kg", pet.weight))
                                    Text("Informações: \(pet.infos)")
                                    Text("Sexo: \(pet.gender.rawValue)")
                                    Text("Documentos: \(pet.petDocuments.count) documento(s)")
                                }
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
                        }
                    }
                }
                .navigationDestination(for: PetFlowDestination.self) { destination in
                    switch destination {
                    case .petDocuments:
                        PetDocumentsView(petCreationViewModel: petCreationViewModel, path: $path)
                    case .petMedicalConditions:
                        PetMedicalConditionsView(petCreationViewModel: petCreationViewModel, path: $path)
                    case .petProfile:
                        PetProfileView(petCreationViewModel: petCreationViewModel, path: $path)
                    case .petBasicInfo:
                        PetBasicInfoView(petCreationViewModel: petCreationViewModel, path: $path
                        )
                    }
                }
            }
        }
    }
}
