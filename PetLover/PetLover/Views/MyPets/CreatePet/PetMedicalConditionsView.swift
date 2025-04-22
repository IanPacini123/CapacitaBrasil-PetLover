//
//  PetMedicalView.swift
//  PetLover
//
//  Created by Izadora Montenegro on 07/04/25.
//

import SwiftUI

struct PetMedicalConditionsView: View {
    @ObservedObject var petCreationViewModel: PetCreationViewModel
    @Environment(\.dismiss) var dismiss
    @Binding var path: NavigationPath
    
    @State private var isWeightPickerPresented = false
    @State private var buttonPressed = false
    
    private let weightValues: [Double] = stride(from: 0.1, through: 100, by: 0.1).map { $0 }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("Condições Médicas")
                        .appFontDarkerGrotesque(darkness: .SemiBold, size: 24)
                    Text("Falta pouco! Adicione aqui informações a respeito do peso, alergias, e tudo o que achar relevante.")
                        .appFontDarkerGrotesque(darkness: .Regular, size: 17)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                    PageProgressBar(totalPages: 4, currentPage: 3)
                        .padding(.horizontal, 70)
                        .padding(.top, 8)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Castração")
                        .appFontDarkerGrotesque(darkness: .ExtraBold, size: 19)
                    HStack {
                        ForEach(CastrationStatus.allCases) { status in
                            Button {
                                petCreationViewModel.castrationStatus = status
                            } label: {
                                Text(status.displayText)
                                    .appFontDarkerGrotesque(darkness: .Bold, size: 17)
                                    .foregroundStyle(status == petCreationViewModel.castrationStatus ? .white : .black)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 42)
                                    .background(
                                        Group {
                                            if (petCreationViewModel.castrationStatus == status) {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .foregroundStyle(Color.AppColors.secondary40Blue)
                                            } else {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(lineWidth: 0.8)
                                                    .foregroundStyle(.black)
                                            }
                                        }
                                    )
                            }
                        }
                    }
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Peso")
                        .appFontDarkerGrotesque(darkness: .ExtraBold, size: 19)
                        .padding(.leading)
                    
                    SeletorInput(
                        label: petCreationViewModel.weight != 0.0 ?
                        "\(String(format: "%.1f", petCreationViewModel.weight)) kg" :
                            "Qual o peso do seu animalzinho?",
                        action: {
                            isWeightPickerPresented = true
                        }
                    )
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Informações adicionais")
                        .appFontDarkerGrotesque(darkness: .ExtraBold, size: 19)
                        .padding(.leading)
                    MultilineTextField(
                        text: $petCreationViewModel.infos,
                        buttonPressed: $buttonPressed,
                        placeholder: "Fique à vontade para adicionar informações sobre seu pet, como alergias, remédios em uso, etc..."
                    )
                }
                Spacer()
            }
            .padding(.top, 40)
        }
        .background(Color.AppColors.nearNeutralLightLightGray.ignoresSafeArea())
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
                Button {
                    path.append(PetFlowDestination.petDocuments)
                } label: {
                    Text("Avançar")
                        .appFontDarkerGrotesque(darkness: .SemiBold, size: 17)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .sheet(isPresented: $isWeightPickerPresented) {
            weightPickerSheet
        }
    }
    
    private var weightPickerSheet: some View {
        VStack {
            Picker("Peso", selection: Binding(
                get: { petCreationViewModel.weight ?? 1.0 },
                set: { petCreationViewModel.weight = $0 }
            )) {
                ForEach(weightValues, id: \.self) { weight in
                    Text("\(String(format: "%.1f", weight)) kg").tag(weight)
                }
            }
            .labelsHidden()
            .pickerStyle(WheelPickerStyle())
            
            Button("Confirmar") {
                isWeightPickerPresented = false
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.AppColors.primary50Orange)
            .foregroundStyle(.white)
            .cornerRadius(12)
            .padding(.horizontal)
        }
        .background(
            Color.AppColors.nearNeutralLightLightGray.ignoresSafeArea()
        )
        .presentationDetents([.fraction(0.4)])
    }
}
