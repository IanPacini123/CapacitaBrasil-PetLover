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
    
    @Binding var returnSwitch: Bool
    
    @State var isSelected: Bool = false
    @State var isShowingDetails: Bool = false
    
    var action: () -> Void
    var proxyFunc: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                Group {
                    if let data = pet.photo, let image = UIImage(data: data) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: isSelected ? 224 : 150)
                            .clipShape(CustomRoundedRectangle(topRadius: isSelected ? 0 : 16, bottomRadius: 16))
                    } else {
                        Image("Fotossintese")
                            .resizable()
                            .scaledToFill()
                            .frame(height: isSelected ? 224 : 150)
                            .clipShape(CustomRoundedRectangle(topRadius: isSelected ? 0 : 16, bottomRadius: 16))
                    }
                }
                .zIndex(1)
                .padding(2)
                .background {
                    CustomRoundedRectangle(topRadius: isSelected ? 0 : 20, bottomRadius: 20)
                        .foregroundStyle(Color.AppColors.secondary60BlueishGray)
                }
                CustomRoundedRectangle(topRadius: 20, bottomRadius: 0)
                    .frame(height: 46)
                    .foregroundStyle(Color.AppColors.primary20NearWhite)
                    .overlay {
                        HStack {
                            Text(pet.name)
                                .appFontDarkerGrotesque(darkness: .Black, size: 23)
                            
                            Spacer()
                            
                            if !isSelected {
                                Text("\(pet.petAge) anos")
                                    .appFontDarkerGrotesque(darkness: .SemiBold, size: 20)
                            }
                        }
                        .padding(.horizontal, 28)
                    }
                    .zIndex(2)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 2)
            }
            .onTapGesture {
                action()
                withAnimation(.linear(duration: 0.2)) {
                    isSelected.toggle()
                } completion: {
                    withAnimation(.bouncy(duration: 0.5)) {
                        isShowingDetails.toggle()
                    } completion: {
                        proxyFunc()
                    }
                }
            }
            .padding(.horizontal,  isSelected ? 0 : 16)
            
            if isShowingDetails {
                PetListCardDetail(pet: pet)
                    .transition (
                        .asymmetric (
                            insertion: .move(edge: .top),
                            removal: .move(edge: .top)
                        )
                    )
                    .zIndex(0)
                    .padding(.horizontal, isSelected ? 18 : (18+16))
                    .padding(.top, -2)
            }
        }
        .clipped()
        .onChange(of: returnSwitch) { oldValue, newValue in
            withAnimation(.linear(duration: 0.2)) {
                isSelected = false
            } completion: {
                withAnimation(.bouncy(duration: 0.5)) {
                    isShowingDetails = false
                } completion: {
                    proxyFunc()
                }
            }
        }
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
                           gender: .male), returnSwitch: .constant(false), action: {}, proxyFunc: {})
}
