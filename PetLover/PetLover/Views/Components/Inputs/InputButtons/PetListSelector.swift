//
//  PetListSelector.swift
//  PetLover
//
//  Created by Izadora Montenegro on 04/04/25.
//
import SwiftUI

struct PetListSelector: View {
    @State var pets: [Pet] = []
    @Binding var selectedPet: Pet?

    var body: some View {
        ForEach(pets, id: \.self) { pet in
            HStack {
                PetSelectorButton(
                    pet: pet,
                    isSelected: selectedPet == pet,
                    onSelect: {
                        selectedPet = pet
                    }
                )
            }
        }
    }
}
