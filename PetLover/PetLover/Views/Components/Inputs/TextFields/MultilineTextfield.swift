//
//  MultilineTextfield.swift
//  PetLover
//
//  Created by Izadora Montenegro on 27/03/25.
//

import SwiftUI

struct MultilineTextField: View {
    @Binding var text: String
    @Binding var buttonPressed: Bool
    
    var placeholder: String
    var minHeight: CGFloat = 94
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(.custom("Darker Grotesque", size: 14).weight(.medium))
                        .foregroundColor(Color.AppColors.secondary70DarkBlue)
                        .padding(.top, 12)
                        .padding(.leading, 8)
                }
                
                TextEditor(text: $text)
                    .font(.custom("Darker Grotesque", size: 14).weight(.medium))
                    .foregroundColor(.black)
                    .padding(.leading, 4)
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                    .onSubmit {
                        text += "\n"
                    }
                    .frame(minHeight: minHeight)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1)
                    .foregroundColor(buttonPressed && text.isEmpty ? .AppColors.helperErrorRed : .black)
            )
            .padding(.horizontal)
            
            if buttonPressed && text.isEmpty {
                Text("Campo obrigatório. Preencha antes de continuar.")
                    .font(.custom("Darker Grotesque", size: 14).weight(.bold))
                    .foregroundColor(Color.AppColors.helperErrorRed)
                    .padding(.leading)
            }
        }
    }
}

#Preview {
    @Previewable @State var text: String = ""
    @Previewable @State var buttonPressed: Bool = false
    
    VStack {
        MultilineTextField(text: $text, buttonPressed: $buttonPressed, placeholder: "Fique à vontade para adicionar informações sobre seu pet, como alergias, remédios em uso, etc...")
        
        Button(action: {
            if text.isEmpty {
                buttonPressed = true
            } else {
                buttonPressed = false
            }
        }, label: {
            Text("Botão de continuar")
        })
        .padding(.top)
        
    }
}
