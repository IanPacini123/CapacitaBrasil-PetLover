//
//  SpeciesButton.swift
//  PetLover
//
//  Created by Ian Pacini on 14/03/25.
//

import SwiftUI

struct SpeciesButton: View {
    var species: SpeciesOptions
    @Binding var selectedSpecies: SpeciesOptions?
    
    var body: some View {
        Button {
            self.selectedSpecies = self.species
        } label: {
            VStack {
                species.image()
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)
                    .padding(.horizontal, 4)
                    .padding(.bottom, 2)
                
                Text(species.displayName)
                    .appFontDarkerGrotesque(darkness: .Bold, size: 14)
                    .foregroundStyle(.black)
                
            }
            .padding(14)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: isSelected() ? 2 : 1)
                    .foregroundStyle(isSelected() ? Color.AppColors.secondary40Blue : .black)
                    .background(isSelected() ? Color.AppColors.primary20NearWhite : Color.clear)
            }
        }
    }
    
    func isSelected() -> Bool {
        return self.species == self.selectedSpecies
    }
}

#Preview {
    @Previewable @State var selectedSpecies: SpeciesOptions? = .dog
    
    SpeciesButton(species: .dog, selectedSpecies: $selectedSpecies)
}
