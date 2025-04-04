//
//  PetSelector.swift
//  PetLover
//
//  Created by Izadora Montenegro on 04/04/25.
//

import SwiftUI

struct PetSelectorButton: View {
    var pet: Pet
    var isSelected: Bool
    var onSelect: () -> Void

    var body: some View {
        Button(action: {
            onSelect()
        }, label: {
            VStack {
                pet.specie.image()
                Text(pet.name)
                    .appFontDarkerGrotesque(darkness: .Bold, size: 15)
                    .foregroundStyle(Color.AppColors.secondary70DarkBlue)
            }
        })
        .frame(minWidth: 111, minHeight: 102)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: isSelected ? 2 : 1)
                .foregroundStyle(isSelected ? Color.AppColors.secondary40Blue : .black)
                .background(isSelected ? Color.AppColors.primary20NearWhite : Color.clear)
        }
    }
}
