//
//  PetList.swift
//  PetLover
//
//  Created by Ian Pacini on 13/05/25.
//

import SwiftUI

struct PetList: View {
    @Environment(\.modelContext) private var context
    @State var path = NavigationPath()
    
    @State var petCreationViewModel = PetCreationViewModel()
    
    @State var petList: [Pet] = PetViewModel.shared.pets
    
    @State var selectedPet: Pet? = nil
    
    @State var returnSwitch: Bool = false
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                ScrollViewReader { proxy in
                    ForEach(PetViewModel.shared.pets) { pet in
                        PetListCard(pet: pet, returnSwitch: $returnSwitch) {
                            proxy.scrollTo(pet.id, anchor: .top)
                            if selectedPet == nil {
                                self.selectedPet = pet
                            } else {
                                self.selectedPet = nil
                            }
                        } proxyFunc: {
                            proxy.scrollTo(pet.id, anchor: .top)
                        }
                        .id(pet.id)
                        .opacity(selectedPet != nil ? (pet.id == selectedPet?.id ? 1 : 0) : 1)
                    }
                }
            }
            .scrollDisabled(selectedPet != nil)
            .onAppear {
                PetViewModel.shared.fetchPets(context: context)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    if selectedPet != nil {
                        Text("Meu Pet")
                    } else {
                        Text("Meus Pets")
                    }
                }
                
                if selectedPet != nil {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            selectedPet = nil
                            returnSwitch.toggle()
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                    }
                } else {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            path.append(Destination.petBasicInfo)
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Destination.self) { destination in
                switch destination {
                case .petDocuments:
                    PetDocumentsView(petCreationViewModel: $petCreationViewModel, path: $path)
                case .petMedicalConditions:
                    PetMedicalConditionsView(petCreationViewModel: $petCreationViewModel, path: $path)
                case .petProfile:
                    PetProfileView(petCreationViewModel: $petCreationViewModel, path: $path)
                case .petBasicInfo:
                    PetBasicInfoView(petCreationViewModel: $petCreationViewModel, path: $path)
                }
            }
            .safeAreaPadding(.bottom)
            .background {
                Color.AppColors.primary20NearWhite
                    .ignoresSafeArea()
            }
        }
    }
}

struct CustomRoundedRectangle: Shape {
    private var topLeftRadius: CGFloat
    private var topRightRadius: CGFloat
    private var bottomLeftRadius: CGFloat
    private var bottomRightRadius: CGFloat
    
    init(topRadius: CGFloat = 0, bottomRadius: CGFloat = 0) {
        self.topLeftRadius = topRadius
        self.topRightRadius = topRadius
        self.bottomLeftRadius = bottomRadius
        self.bottomRightRadius = bottomRadius
    }
    
    init(topLeftRadius: CGFloat = 0, topRightRadius: CGFloat = 0, bottomLeftRadius: CGFloat = 0, bottomRightRadius: CGFloat = 0) {
        self.topLeftRadius = topLeftRadius
        self.topRightRadius = topRightRadius
        self.bottomLeftRadius = bottomLeftRadius
        self.bottomRightRadius = bottomRightRadius
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Canto Esquerdo de Cima
        path.move(to: .init(x: rect.minX, y: rect.minY + topLeftRadius))
        path.addQuadCurve(to: .init(x: rect.minX + topLeftRadius, y: rect.minY), control: .init(x: rect.minX, y: rect.minY))
        
        // Canto Direito de Cima
        path.addLine(to: .init(x: rect.maxX - topRightRadius, y: rect.minY))
        path.addQuadCurve(to: .init(x: rect.maxX, y: rect.minY + topRightRadius),
                          control: .init(x: rect.maxX, y: rect.minY))
        
        // Canto Direito de Baixo
        path.addLine(to: .init(x: rect.maxX, y: rect.maxY - bottomRightRadius))
        path.addQuadCurve(to: .init(x: rect.maxX - bottomRightRadius, y: rect.maxY),
                          control: .init(x: rect.maxX, y: rect.maxY))
        
        // Canto Esquerdo de Baixo
        path.addLine(to: .init(x: rect.minX + bottomLeftRadius, y: rect.maxY))
        path.addQuadCurve(to: .init(x: rect.minX, y: rect.maxY - bottomLeftRadius),
                          control: .init(x: rect.minX, y: rect.maxY))
        
        path.addLine(to: .init(x: rect.minX, y: rect.minY + topLeftRadius))
        
        return path
        
    }
}


#Preview {
    PetList()
}
