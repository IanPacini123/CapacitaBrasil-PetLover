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
        ZStack(alignment: .top) {
            Color.AppColors.nearNeutralLightLightGray.ignoresSafeArea()
//            Image("HomeTopBackground")
//                .resizable()
//                .scaledToFit()
//                .ignoresSafeArea(edges: .all)

            Rectangle()
                        .fill(Color.white)
                        .frame(maxWidth: .infinity, maxHeight: 380)
                        .cornerRadius(200, corners: [.bottomLeft, .bottomRight])
                        .ignoresSafeArea(.all)
            
        VStack {
            Text("Love My Pet")
                .appFontDarkerGrotesque(darkness: .Black, size: 32)
            
            HStack {
                if !(PetViewModel.shared.pets.isEmpty) {
                    Button(action: {
                        if selectedPetIndex > 0 {
                            selectedPetIndex -= 1
                            petName = PetViewModel.shared.pets[selectedPetIndex].name
                        }
                        print(selectedPetIndex)
                    }, label: {
                        Image("IconChevronRight")
                            .rotationEffect(Angle(degrees: 180))
                            .foregroundStyle(selectedPetIndex == 0 ? Color.AppColors.nearNeutralGrayGray : Color.AppColors.secondary60BlueishGray)
                    })
                }
                
                Spacer()
                
                
                VStack {
                    PetIdentifier(isEmpty: !(PetViewModel.shared.pets.isEmpty), petName: petName, action: {
                        path.append(PetFlowDestination.petBasicInfo)
                    })
                    
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
                            petName = PetViewModel.shared.pets[selectedPetIndex].name
                        }
                        print(PetViewModel.shared.pets)
                        
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

// Extensão para arredondar cantos específicos
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
