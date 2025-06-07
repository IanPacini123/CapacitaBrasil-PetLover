//
//  PetList.swift
//  PetLover
//
//  Created by Ian Pacini on 13/05/25.
//

import SwiftUI

struct PetList: View {
    @Environment(\.modelContext) private var context
    
    @State var petList: [Pet] = PetViewModel.shared.pets
    
    @State var hasSelection: Bool = false
    @State var selectedPet: Pet? = nil
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ScrollViewReader { proxy in
                    ForEach(petList) { pet in
                        if !(pet != selectedPet && hasSelection) {
                            PetListCard(pet: pet) {
                                proxy.scrollTo(pet.id, anchor: .top)
                                hasSelection.toggle()
                                self.selectedPet = pet
                            }
                            .id(pet.id)
                        }
                    }
                }
            }
            .onAppear {
                PetViewModel.shared.fetchPets(context: context)
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
