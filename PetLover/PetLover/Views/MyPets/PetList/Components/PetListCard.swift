//
//  PetListCard.swift
//  PetLover
//
//  Created by Ian Pacini on 26/05/25.
//

import SwiftUI
import QuickLook

struct PetListCard: View {
    var pet: Pet
    
    @State var hPadding: CGFloat = 16
    @State var topRadius: CGFloat = 20
    @State var bottomRadius: CGFloat = 0
    
    @State var isSelected: Bool = false
    @State var isShowingStats: Bool = false
    
    var action: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                CustomRoundedRectangle(topRadius: topRadius, bottomRadius: 20)
                    .stroke(lineWidth: 2)
                    .foregroundStyle(Color.AppColors.secondary60BlueishGray)
                    .background {
                        if let data = pet.photo, let image = UIImage(data: data) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                        } else {
                            Image("Fotossintese")
                                .resizable()
                                .scaledToFill()
                        }
                    }
                    .frame(height: (isSelected ? 224 : 150))
                    .clipShape(CustomRoundedRectangle(topRadius: topRadius, bottomRadius: 20))
                    .padding(.horizontal, hPadding)
                    .onTapGesture {
                        withAnimation {
                            action()
                            
                            isSelected.toggle()
                            if isSelected {
                                hPadding = 0
                                topRadius = 0
                                bottomRadius = 20
                            } else {
                                hPadding = 16
                                topRadius = 20
                                bottomRadius = 0
                            }
                        } completion: {
                            withAnimation {
                                isShowingStats.toggle()
                            }
                        }
                    }
                
                CustomRoundedRectangle(topRadius: 20, bottomRadius: 0)
                    .foregroundStyle(Color.AppColors.primary20NearWhite)
                    .frame(height: 46)
                    .overlay {
                        CustomRoundedRectangle(topRadius: 20, bottomRadius: 0)
                            .stroke(lineWidth: 2)
                            .foregroundStyle(Color.AppColors.secondary60BlueishGray)
                    }
                    .overlay {
                        HStack {
                            Text(pet.name)
                                .appFontDarkerGrotesque(darkness: .Black, size: 23)
                            
                            Spacer()
                            
                            if !isSelected {
                                Text("\(pet.petAge) ANOS")
                                    .appFontDarkerGrotesque(darkness: .SemiBold, size: 20)
                            }
                        }
                        .foregroundStyle(Color.AppColors.secondary60BlueishGray)
                        .padding(.horizontal, 28)
                    }
                    .padding(.horizontal, 36)
                    .zIndex(1)
            }
            .zIndex(1)
            
            if isShowingStats {
                PetListCardDetail(pet: pet)
                .transition (
                    .asymmetric (
                        insertion: .move(edge: .top),
                        removal: .move(edge: .top)
                    )
                )
                .padding(.horizontal, 36)
                .zIndex(0)
            }
        }
        .clipped()
    }
}

#Preview {
    PetListCard(pet: .init(name: "Fotossintese",
                           birthDate: .now,
                           specie: .dog,
                           breed: "Demonio",
                           castrationStatus: .yes,
                           weight: 6.90,
                           infos: "De oliveira",
                           gender: .male), action: {})
}
