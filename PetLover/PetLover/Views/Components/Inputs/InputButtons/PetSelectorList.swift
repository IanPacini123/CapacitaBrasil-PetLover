//
//  PetListSelector.swift
//  PetLover
//
//  Created by Izadora Montenegro on 04/04/25.
//
import SwiftUI

struct PetSelectorList: View {
    @State var pets: [Pet] = []
    @Binding var selectedPet: Pet?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(pets, id: \.self) { pet in
                    Button(action: {
                        if selectedPet == pet {
                            selectedPet = nil
                        } else {
                            selectedPet = pet
                        }
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
                            .stroke(lineWidth: selectedPet == pet ? 2 : 1)
                            .foregroundStyle(selectedPet == pet ? Color.AppColors.secondary40Blue : .black)
                            .background(selectedPet == pet ? Color.AppColors.primary20NearWhite : Color.clear)
                    }
                }
            }
            .padding(.vertical)
        }
    }
}
