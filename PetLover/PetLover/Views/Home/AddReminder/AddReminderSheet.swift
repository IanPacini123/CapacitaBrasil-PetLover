//
//  AddReminderSheet.swift
//  PetLover
//
//  Created by Ian Pacini on 08/04/25.
//

import SwiftUI

struct AddReminderSheet: View {
    @State var selectedpet: Pet? = nil
    
    @Binding var isShowing: Bool
    
    var pets: [Pet] = []
    
    var body: some View {
        VStack{
            HStack {
                Button {
                    print("Voltar")
                } label: {
                    Image(systemName: "multiply")
                        .font(.custom("", size: 30))
                }
                
                Spacer()
                
                Button {
                    print("Concluir")
                } label: {
                    Text("Concluir")
                        .appFontDarkerGrotesque(darkness: .SemiBold, size: 17)
                }
            }
            .foregroundStyle(Color.AppColors.secondary60BlueishGray)
            .padding(.horizontal, 18)
            .padding(20)
            .overlay {
                Text("Adicionar")
                    .appFontDarkerGrotesque(darkness: .Black, size: 32)
                    .foregroundStyle(Color.AppColors.secondary60BlueishGray)
            }
            Form {
                Section {
                    PetSelectorList(pets: [.init(name: "Passsaro Testeeeeeeeeeeeeee", birthDate: .now, specie: .bird, breed: "", photo: nil, castrationStatus: .yes, weight: 10, infos: "", gender: .male)],selectedPet: $selectedpet)
                } header: {
                    Text("Selecione o seu pet")
                        .appFontDarkerGrotesque(darkness: .ExtraBold, size: 19)
                        .foregroundStyle(.black)
                }
                
                Section {
                    SinglelineTextField(text: .constant(""), buttonPressed: .constant(false), label: "")
                } header: {
                    Text("Título do Lembrete")
                        .appFontDarkerGrotesque(darkness: .ExtraBold, size: 19)
                        .foregroundStyle(.black)
                }
                
                Section {
                    ScrollView(.horizontal) {
                        HStack {
                            InputButton(label: "Eventos", isSelected: .constant(false))
                            InputButton(label: "Cuidados diários", isSelected: .constant(false))
                            InputButton(label: "Saúde", isSelected: .constant(false))
                        }
                    }
                        .font(.appFontDarkerGrotesque(darkness: .Bold, size: 17))
                } header: {
                    Text("Categoria")
                        .appFontDarkerGrotesque(darkness: .ExtraBold, size: 19)
                        .foregroundStyle(.black)
                }


            }
            .formStyle(.columns)
            .scrollContentBackground(.hidden)
        }
        .padding()
        Spacer()
    }
}

#Preview {
    @Previewable @State var isShowing = true
    
    VStack {
        Button("Abrir sheet") {
            isShowing = true
        }
    }
    .sheet(isPresented: $isShowing) {
        AddReminderSheet(isShowing: $isShowing)
    }
}
