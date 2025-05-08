//
//  PetHomeView.swift
//  PetLover
//
//  Created by Izadora Montenegro on 07/05/25.
//
import SwiftUI

struct PetHomeView: View {
    @Binding var path: NavigationPath
    
    @Environment(\.modelContext) private var context
    
    @State var currentPet: Pet?
    
    private var viewModel = PetViewModel.shared
    
    init(path: Binding<NavigationPath>) {
        self._path = path
    }
    
    @State var selectedPetIndex = 0
    @State var petName: String = ""

    var body: some View {
        VStack {
            HStack {
                
                Button(action: {
                    if selectedPetIndex > 0 {
                        selectedPetIndex -= 1
                        petName = PetViewModel.shared.pets[selectedPetIndex].name // Atualizando o nome do pet
                    }
                }, label: {
                    Text("<")
                })
                
                Button(action: {
                    if selectedPetIndex < PetViewModel.shared.pets.count - 1 {
                        selectedPetIndex += 1
                        petName = PetViewModel.shared.pets[selectedPetIndex].name // Atualizando o nome do pet
                    }
                }, label: {
                    Text(">")
                })
            }
            
            PetIdentifier(isEmpty: !(PetViewModel.shared.pets.isEmpty), petName: petName, action: {
                
            })
                
            if !PetViewModel.shared.pets.isEmpty {
                Text(PetViewModel.shared.pets[selectedPetIndex].name)
            }
            
            ForEach(PetViewModel.shared.pets, id: \.self) { pet in
                HStack {
                    Text(pet.name)
                }
            }
            
            InlineCalendar()
            
            VStack {
                HStack {
                    Text("Lembretes")
                        .appFontDarkerGrotesque(darkness: .Black, size: 28)
                    Spacer()
                    Image("IconPlus")
                }
                .padding(.horizontal)
                .foregroundStyle(Color.AppColors.secondary60BlueishGray)
            }
        }
        .onAppear {
            if !PetViewModel.shared.pets.isEmpty {
                petName = PetViewModel.shared.pets[selectedPetIndex].name
            }
            PetViewModel.shared.fetchPets(context: context)
        }
    }
}
