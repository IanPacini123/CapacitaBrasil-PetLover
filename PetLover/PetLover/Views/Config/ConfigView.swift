//
//  ConfigView.swift
//  PetLover
//
//  Created by Ian Pacini on 06/06/25.
//

import SwiftUI

struct ConfigView: View {
    @State var hasNotifications: Bool = true
    @State var showingDeleteAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        Toggle(isOn: $hasNotifications) {
                            Text("Notificações")
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 44)
                        .background(optionBackground)
                        .padding(.horizontal, 16)
                        
                        HStack {
                            Text("Apagar dados")
                            
                            Spacer()
                            
                            Button {
                                showingDeleteAlert.toggle()
                            } label: {
                                Image(systemName: "trash.fill")
                                    .font(.system(size: 20))
                                    .bold()
                                    .foregroundStyle(Color.AppColors.helperErrorRed)
                            }
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 44)
                        .background(optionBackground)
                        .padding(.horizontal, 16)
                    }
                }
                
                if showingDeleteAlert {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                }
            }
            .background {
                Color.AppColors.primary20NearWhite
                    .ignoresSafeArea()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Ajustes")
                        .appFontDarkerGrotesque(darkness: .Black, size: 32)
                }
            }
            .sheet(isPresented: $showingDeleteAlert) {
                DeletionSheet(showingDeleteAlert: $showingDeleteAlert)
            }
        }
    }
    
    var optionBackground: some View {
        RoundedRectangle(cornerRadius: 8)
            .foregroundStyle(.white)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(Color.AppColors.secondary60BlueishGray)
            }
    }
}

struct DeletionSheet: View {
    @Environment(\.modelContext) private var context
    @State var petViewModel = PetViewModel.shared
    
    @Binding var showingDeleteAlert: Bool
    
    var body: some View {
        VStack(spacing: 14) {
            HStack {
                Text("Apagar dados?")
                
                Spacer()
                
                Button {
                    showingDeleteAlert.toggle()
                } label: {
                    Image(systemName: "multiply")
                }
                .padding(.trailing, 16)
            }
            .font(.appFontDarkerGrotesque(darkness: .Black, size: 32))
            
            Group {
                Text("Tem certeza que deseja excluir todos os seus dados deste aplicativo? ") +
                Text("Essa ação é permanente").foregroundStyle(Color.AppColors.helperErrorRed) +
                Text(" e não poderá ser desfeita")
            }
            .padding(.vertical, 24)
            
            Button {
                deleteAllPets()
                showingDeleteAlert.toggle()
            } label: {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(Color.AppColors.helperErrorRed)
                    .overlay {
                        Text("Sim, apagar dados")
                            .foregroundStyle(.white)
                    }
                    .frame(height: 44)
            }
            .font(.appFontDarkerGrotesque(darkness: .Bold, size: 22))
            
            Button {
                showingDeleteAlert.toggle()
            } label: {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1)
                    .overlay {
                        Text("Cancelar")
                    }
                    .frame(height: 44)
            }
            .font(.appFontDarkerGrotesque(darkness: .Bold, size: 22))
        }
        .padding(.horizontal, 16)
        .foregroundStyle(Color.AppColors.secondary60BlueishGray)
        .font(.appFontDarkerGrotesque(darkness: .Bold, size: 17))
        .presentationDetents([.fraction(0.4)])
    }
    
    private func deleteAllPets() {
        petViewModel.pets.forEach { pet in
            petViewModel.deletePet(context: context, pet: pet)
        }
    }
}

#Preview {
    ConfigView()
}
