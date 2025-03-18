//
//  AddPetButton.swift
//  PetLover
//
//  Created by Izadora Montenegro on 11/03/25.
//

import SwiftUI

struct AddPetButton: View {
    var body: some View {
        VStack(spacing: 9) {
            VStack {
                ZStack {
                    Circle()
                        .stroke(Color.AppColors.primary40LightOrange, lineWidth: 6)
                    Circle()
                        .foregroundStyle(Color.AppColors.primary20NearWhite)
                        .overlay(
                            Image("IconPawSpecies")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(Color.AppColors.primary40LightOrange)
                                .padding(.horizontal, 34)
                        )
                }
            }
            
            
            LargeButton(label: "Adicionar Pet") {
                print("Peti adicionado")
            }
            .padding(.bottom, 310)
        }
        .padding(120)
        .frame(maxWidth: .infinity)
    }
}

//esses paddings 🤨


#Preview {
    AddPetButton()
}
