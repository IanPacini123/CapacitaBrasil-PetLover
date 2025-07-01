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
    @Environment(\.dismiss) var dismiss
    
    @Binding var petCreationViewModel: PetCreationViewModel
    @Binding var path: NavigationPath
    
    @State private var showGenderPicker: Bool = false
    @State private var showDatePicker: Bool  = false
    @State private var buttonPressed: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                PetFormHeader(title: "Informações básicas", text: "Insira as informações primárias do seu pet!", totalPages: 4, currentPage: 1)
                
                VStack(alignment: .leading, spacing: 24) {
                    SinglelineTextField(text: $petCreationViewModel.name, buttonPressed: $buttonPressed, isOptional: false, label: "Insira o nome do seu animalzinho", fieldTitle: "Nome do pet")
                        .padding(.horizontal)
                    
                        SeletorInput(vazio: petCreationViewModel.birthDate != nil ? false : true, buttonPressed: $buttonPressed, isOptional: false, label: petCreationViewModel.birthDate != nil ? formattedDate(petCreationViewModel.birthDate!) : "Selecione qual a data de nascimento", action: {
                            showDatePicker = true
                        }, fieldTitle: "Data de nascimento")
                    
                        SeletorInput(vazio: false, buttonPressed: $buttonPressed, isOptional: true, label: (petCreationViewModel.gender != nil) ? petCreationViewModel.gender!.displayText : "Qual o gênero do seu pet?", action: {
                            showGenderPicker = true
                        }, fieldTitle: "Genero")
                        
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Espécie")
                            .appFontDarkerGrotesque(darkness: .ExtraBold, size: 19)
                        
                        if buttonPressed && petCreationViewModel.specie == nil {
                            Text("Campo obrigatório. Selecione antes de continuar.")
                                .font(.custom("Darker Grotesque", size: 14).weight(.medium))
                                .foregroundColor(Color.AppColors.helperErrorRed)
                        }
                        
                        HStack {
                            ForEach(SpeciesOptions.allCases) { species in
                                SpeciesButton(species: species, selectedSpecies: $petCreationViewModel.specie)
                            }
                        }
                    }
                    .padding(.leading)
                    
                    SinglelineTextField(text: $petCreationViewModel.breed, buttonPressed: $buttonPressed, isOptional: true, label: "Qual a raça do seu pet?", fieldTitle: "Raça")
                        .padding(.horizontal)
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
                    if petCreationViewModel.birthDate == nil || petCreationViewModel.specie == nil || petCreationViewModel.name.isEmpty {
                        buttonPressed = true
                    } else {
                        buttonPressed = false
                        path.append(Destination.petProfile)
                    }
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
