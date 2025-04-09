//
//  PetMedicalView.swift
//  PetLover
//
//  Created by Izadora Montenegro on 07/04/25.
//

import SwiftUI

struct PetMedicalView: View {
    @Environment(\.dismiss) var dismiss
    @State var petWeight: Double?
    @State var isWeightPickerPresented = false
    @State var castrationStatus: CastrationStatus?
    @State var petInfos: String = ""
    @State var buttonPressed: Bool = false

    let weightValues: [Double] = stride(from: 0.1, through: 100, by: 0.1).map { $0 }

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

                    PageProgressBar(totalPages: 5, currentPage: 3)
                        .padding(.horizontal, 70)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Castração")
                        .appFontDarkerGrotesque(darkness: .SemiBold, size: 19)
                    HStack {
                        ForEach(CastrationStatus.allCases) { status in
                            Button(action: {
                                castrationStatus = status
                            }, label: {
                                Text(status.displayText)
                                    .appFontDarkerGrotesque(darkness: .Bold, size: 17)
                                    .foregroundStyle(status == castrationStatus ? .white : .black)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 42)
                                    .background {
                                        if status == castrationStatus {
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundStyle(Color.AppColors.secondary40Blue)
                                        } else {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(lineWidth: 1)
                                                .foregroundStyle(.black)
                                        }
                                    }
                            })
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Peso")
                        .appFontDarkerGrotesque(darkness: .SemiBold, size: 19)
                        .padding(.leading)

                    SeletorInput(
                        label: petWeight != nil ? "\(String(format: "%.1f", petWeight!)) kg" : "Qual o peso do seu animalzinho?",
                        action: {
                            isWeightPickerPresented = true
                        }
                    )
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Informações adicionais")
                        .appFontDarkerGrotesque(darkness: .SemiBold, size: 19)
                        .padding(.leading)
                    MultilineTextField(text: $petInfos, buttonPressed: $buttonPressed, placeholder: "Fique à vontade para adicionar informações sobre seu pet, como alergias, remédios em uso, etc...")
                }

                Spacer()
            }
            .padding(.top, 60)
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
        .sheet(isPresented: $isWeightPickerPresented) {
            VStack {
                Picker("Peso", selection: Binding(
                    get: { petWeight ?? 1.0 },
                    set: { petWeight = $0 }
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
}


#Preview {
    PetMedicalView()
}
