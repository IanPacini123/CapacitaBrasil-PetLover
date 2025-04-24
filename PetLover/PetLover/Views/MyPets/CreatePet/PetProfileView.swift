//
//  PetProfileView.swift
//  PetLover
//
//  Created by Izadora Montenegro on 07/04/25.
//

import SwiftUI
import PhotosUI

// substituir aqui o botau

struct PetProfileView: View {
    @ObservedObject var petCreationViewModel: PetCreationViewModel
    @Environment(\.dismiss) var dismiss
    @Binding var path: NavigationPath
    
    @State private var selectedItem: PhotosPickerItem? = nil

    var body: some View {
        VStack(spacing: 24) {
            PetFormHeader(title: "Perfil do Pet", text: "Escolha uma foto (.png, .jpeg) para o perfil do seu pet.", totalPages: 4, currentPage: 2)

            if let imageData = petCreationViewModel.photo,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 180, height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding()
            } else {
                VStack(spacing: 19) {
                    Image("IconDog")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .padding(25)
                        .background {
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(lineWidth: 1.2)
                                .foregroundStyle(Color.AppColors.secondary60BlueishGray)
                                .background(.white)
                        }
                    
                    Text("Escolha uma foto para ").appFontDarkerGrotesque(darkness: .Regular, size: 18) +
                    Text("Fotossíntese").bold()
                        .appFontDarkerGrotesque(darkness: .Regular, size: 18)
                }
                
            }

            VStack(spacing: 13) {
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Text(selectedItem != nil ? "Alterar foto" : "Adicionar foto")
                        .appFontDarkerGrotesque(darkness: .Bold, size: 22)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color.AppColors.primary50Orange)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            petCreationViewModel.photo = data
                        }
                    }
                }
                
                LargeButton(label: "Pular", type: .secondary, action: {
                    petCreationViewModel.photo = nil
                    path.append(PetFlowDestination.petMedicalConditions)
                })
                .padding(.horizontal)
                .frame(height: 44)
            }
            Spacer()
        }
        .padding(.top, 40)
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
               path.append(PetFlowDestination.petMedicalConditions)
                }) {
                   Text("Avançar")
                        .appFontDarkerGrotesque(darkness: .SemiBold, size: 17)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}
