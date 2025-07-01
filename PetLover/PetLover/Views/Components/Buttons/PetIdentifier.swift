//
//  AddPetButton.swift
//  PetLover
//
//  Created by Izadora Montenegro on 11/03/25.
//

import SwiftUI

struct PetIdentifier: View {
    
    var viewModel = PetViewModel.shared
    
    @State var isEmpty: Bool
    @State var petName: String
    @State var petImageData: Data?
    var action = {
        
    }
    
    var body: some View {
        VStack {
            if PetViewModel.shared.pets.isEmpty {
                VStack {
                    ZStack {
                        Circle()
                            .stroke(Color.AppColors.primary40LightOrange, lineWidth: 6)
//                            .frame(width: 142)
                        Circle()
//                            .frame(width: 142)
                            .foregroundStyle(Color.AppColors.primary20NearWhite)
                            .overlay(
                                Image("IconPaw")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 74, height: 74)
                                    .foregroundStyle(Color.AppColors.primary40LightOrange)
                            )
                    }
                    .padding(.bottom, 9)
                    
                    LargeButton(label: "Adicionar Pet") {
                        action()
                    }
                    .frame(width: 149, height: 44)
                }
            } else {
                VStack {
                    ZStack {
                        Circle()
                            .stroke(Color.AppColors.primary40LightOrange, lineWidth: 9)
//                            .frame(width: 142)
                        
                        Circle()
//                            .frame(width: 142)
                            .foregroundStyle(Color.AppColors.primary20NearWhite)
                           
                                .overlay(
                                    Group {
                                        if let data = petImageData, let uiImage = UIImage(data: data) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFill()
                                                .clipShape(Circle())
                                        } else {
                                            Image("IconPaw")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundStyle(Color.AppColors.primary40LightOrange)
                                                .frame(width: 74, height: 74)
                                        }
                                    }
                                )
                        
                        Circle()
                            .stroke(Color.AppColors.secondary60BlueishGray, lineWidth: 3)
//                            .frame(width: 142)
                    }
                    .padding(.bottom, 9)
                    
                    Text(petName)
                        .appFontDarkerGrotesque(darkness: .Black, size: 22)
                        .foregroundStyle(Color.AppColors.primary60Brown)
                }
            }
        }
    }
}
