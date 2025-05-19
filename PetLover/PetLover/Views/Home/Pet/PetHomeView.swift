//
//  PetHomeView.swift
//  PetLover
//
//  Created by Izadora Montenegro on 07/05/25.
//
import SwiftUI

struct PetHomeView: View {
    @Binding var path: NavigationPath
    @State private var hasLoadedPets = false

    
    @Environment(\.modelContext) private var context
    
    @State var currentPet: Pet?
    
    private var viewModel = PetViewModel.shared
    
    init(path: Binding<NavigationPath>) {
        self._path = path
    }
    
    @State var selectedPetIndex = 0
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.AppColors.nearNeutralLightLightGray.ignoresSafeArea()
            
            RoundedCorner()
                .fill(Color.white)
                .frame(maxHeight: 380)
                .ignoresSafeArea(.all)
            
            VStack {
                Text("Love My Pet")
                    .appFontDarkerGrotesque(darkness: .Black, size: 32)
                
                HStack {
                    if !(PetViewModel.shared.pets.isEmpty) {
                        Button(action: {
                            if selectedPetIndex > 0 {
                                selectedPetIndex -= 1
                                currentPet = PetViewModel.shared.pets[selectedPetIndex]
                            }
                            print(selectedPetIndex)
                        }, label: {
                            Image("IconChevronRight")
                                .rotationEffect(Angle(degrees: 180))
                                .foregroundStyle(selectedPetIndex == 0 ? Color.AppColors.nearNeutralGrayGray : Color.AppColors.secondary60BlueishGray)
                        })
                    }
                    
                    Spacer()
                    
                    
                    VStack(spacing: 8) {
                        PetIdentifier(isEmpty: false, petName: currentPet?.name ?? "", petImageData: currentPet?.photo, action: {
                            path.append(PetFlowDestination.petBasicInfo)
                        })
                        .id(currentPet)
                        
                        if !(PetViewModel.shared.pets.isEmpty) {
                            IndicatorBar(numberOfPages: PetViewModel.shared.pets.count, currentPage: $selectedPetIndex)
                        }
                    }
                    
                    Spacer()
                    
                    if !(PetViewModel.shared.pets.isEmpty) {
                        Button(action: {
                            print(selectedPetIndex)
                            if selectedPetIndex < PetViewModel.shared.pets.count - 1 {
                                selectedPetIndex += 1
                                currentPet = PetViewModel.shared.pets[selectedPetIndex]
                            }
                            
                        }, label: {
                            Image("IconChevronRight")
                                .foregroundStyle((selectedPetIndex + 1) == PetViewModel.shared.pets.count ? Color.AppColors.nearNeutralGrayGray : Color.AppColors.secondary60BlueishGray)
                            
                        })
                    }
                }
                .padding(.horizontal)
                
                            InlineCalendar()
                                .padding(.horizontal)
                
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
                
                Button(action: {
                    path.append(PetFlowDestination.petBasicInfo)
                }, label: {
                    Text("adicionar pet")
                })
            }
        }
        .onAppear {
            PetViewModel.shared.fetchPets(context: context)
            
            if !PetViewModel.shared.pets.isEmpty {
                currentPet = PetViewModel.shared.pets[selectedPetIndex]
                print(currentPet?.name)
            }
        }
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: .init(x: rect.minX, y: rect.minY))
        
        path.addLine(to: .init(x: rect.maxX, y: rect.minY))
        path.addLine(to: .init(x: rect.maxX, y: rect.maxY/2))
        
        path.addQuadCurve(to: .init(x: rect.midX, y: rect.maxY), control: .init(x: rect.maxX, y: rect.maxY))
        
        path.addQuadCurve(to: .init(x: rect.minX, y: rect.midY), control: .init(x: rect.minX, y: rect.maxY))
        
        path.addLine(to: .init(x: rect.minX, y: rect.minY))
        
        
        return Path(path.cgPath)
    }
}


