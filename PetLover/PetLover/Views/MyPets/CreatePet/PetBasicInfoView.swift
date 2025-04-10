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
    @StateObject var viewModel = PetCreationViewModel()
    @Environment(\.dismiss) var dismiss
    @Binding var path: NavigationPath
    
    @State private var showGenderPicker: Bool = false
    @State private var showDatePicker: Bool  = false
    @State private var buttonPressed: Bool = false
    
    @State private var petBirthDate: Date?
    @State private var petGender: GenderOptions?
    @State private var petSpecies: SpeciesOptions?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("Informações básicas")
                        .appFontDarkerGrotesque(darkness: .SemiBold, size: 24)
                    Text("Insira as informações primárias do seu pet!")
                        .appFontDarkerGrotesque(darkness: .Regular, size: 17)
                    PageProgressBar(totalPages: 5, currentPage: 1)
                        .padding(.horizontal, 70)
                }
                .padding(.top)
                
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nome do pet")
                            .appFontDarkerGrotesque(darkness: .SemiBold, size: 19)
                            .padding(.leading)
                        SinglelineTextField(text: $viewModel.name, buttonPressed: $buttonPressed, label: "Insira o nome do seu animalzinho")
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Data de nascimento")
                            .appFontDarkerGrotesque(darkness: .SemiBold, size: 19)
                            .padding(.leading)
                        SeletorInput(label: petBirthDate != nil ? formattedDate(petBirthDate!) : "Selecione qual a data de nascimento", action: {
                            showDatePicker = true
                        })
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Gênero")
                            .appFontDarkerGrotesque(darkness: .SemiBold, size: 19)
                            .padding(.leading)
                        SeletorInput(label: (petGender != nil) ? petGender!.displayText : "Qual o gênero do seu pet?", action: {
                            showGenderPicker = true
                        })
                        
                    }
                    
//                    VStack(alignment: .leading, spacing: 8) {
//                        Text("Espécie")
//                            .appFontDarkerGrotesque(darkness: .SemiBold, size: 19)
//                        
//                        HStack {
//                            ForEach(Species.allCases) { species in
//                                SpeciesButton(species: species, selectedSpecies: $petSpecies)
//                            }
//                        }
//                    }
//                    .padding(.leading)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Raça")
                            .appFontDarkerGrotesque(darkness: .SemiBold, size: 19)
                            .padding(.leading)
                        SinglelineTextField(text: $viewModel.breed, buttonPressed: $buttonPressed, label: "Insira o nome do seu animalzinho")
                    }
                }
            }
            .sheet(isPresented: $showGenderPicker) {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Selecione o gênero:")
                        .appFontDarkerGrotesque(darkness: .SemiBold, size: 20)
                    
                    Button(action: {
                        petGender = .female
                        showGenderPicker = false
                    }, label: {
                        Text("Fêmea")
                            .foregroundStyle(petGender == .female ? .white : .black)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 130)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: 2)
                                    .foregroundStyle(.black)
                            }
                    })
                    
                    Button(action: {
                        petGender = .male
                        showGenderPicker = false
                    }, label: {
                        Text("Macho")
                            .foregroundStyle(petGender == .male ? .white : .black)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 130)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: 2)
                                    .foregroundStyle(.black)
                                
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
                            get: { petBirthDate ?? Date() },
                            set: { petBirthDate = $0 }
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
                    viewModel.birthDate = petBirthDate ?? Date()
                    viewModel.gender = petGender ?? .female
                    viewModel.specie = petSpecies ?? .dog
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

#Preview {
    PetBasicInfoView(
        path: .constant(NavigationPath())
    )
}
