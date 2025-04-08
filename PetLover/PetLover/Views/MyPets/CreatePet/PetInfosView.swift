//
//  PetInfosView.swift
//  PetLover
//
//  Created by Izadora Montenegro on 07/04/25.
//

import SwiftUI
import Foundation

struct PetInfosView: View {
    @Environment(\.dismiss) var dismiss
    @State var showGenderPicker = false
    @State var showDatePicker = false
    @State var buttonPressed: Bool = false
    
    @State var petName: String = ""
    @State var birthDate: Date?
    @State var gender: GenderOptions?
    @State var selectedSpecie: Species?
    @State var breed = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack {
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
                        SinglelineTextField(text: $petName, buttonPressed: $buttonPressed, label: "Insira o nome do seu animalzinho")
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Data de nascimento")
                            .appFontDarkerGrotesque(darkness: .SemiBold, size: 19)
                            .padding(.leading)
                        SeletorInput(label: birthDate != nil ? formattedDate(birthDate!) : "Selecione qual a data de nascimento", action: {
                            showDatePicker = true
                        })
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Gênero")
                            .appFontDarkerGrotesque(darkness: .SemiBold, size: 19)
                            .padding(.leading)
                        SeletorInput(label: (gender != nil) ? gender!.displayText : "Qual o gênero do seu pet?", action: {
                            showGenderPicker = true
                        })
                        
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Espécie")
                            .appFontDarkerGrotesque(darkness: .SemiBold, size: 19)
                        
                        HStack {
                            ForEach(Species.allCases) { species in
                                SpeciesButton(species: species, selectedSpecies: $selectedSpecie)
                            }
                        }
                    }
                    .padding(.leading)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Raça")
                            .appFontDarkerGrotesque(darkness: .SemiBold, size: 19)
                            .padding(.leading)
                        SinglelineTextField(text: $breed, buttonPressed: $buttonPressed, label: "Insira o nome do seu animalzinho")
                    }
                }
            }
            .sheet(isPresented: $showGenderPicker) {
                VStack(spacing: 24) {
                    Text("Selecione o gênero")
                        .appFontDarkerGrotesque(darkness: .SemiBold, size: 20)
                    
                    Button(action: {
                        gender = .female
                        showGenderPicker = false
                    }, label: {
                        Text("Fêmea")
                            .foregroundStyle(gender == .female ? .white : .black)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 42)
                            .background {
                                if gender == .female {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(Color.AppColors.secondary40Blue)
                                } else {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(lineWidth: 2)
                                        .foregroundStyle(.black)
                                }
                                
                            }
                    })
                    
                    Button(action: {
                        gender = .male
                        showGenderPicker = false
                    }, label: {
                        Text("Macho")
                            .foregroundStyle(gender == .male ? .white : .black)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 42)
                            .background {
                                if gender == .male {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(Color.AppColors.secondary40Blue)
                                } else {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(lineWidth: 2)
                                        .foregroundStyle(.black)
                                }
                            }
                    })
                    
                }
                .padding()
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
                            get: { birthDate ?? Date() },
                            set: { birthDate = $0 }
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
                   // nav path aqui
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
    PetInfosView()
}
