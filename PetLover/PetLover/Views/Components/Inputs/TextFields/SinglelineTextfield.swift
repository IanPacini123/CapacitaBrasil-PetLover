//
//  SinglelineTextfield.swift
//  PetLover
//
//  Created by Izadora Montenegro on 27/03/25.
//

import SwiftUI

struct SinglelineTextField: View {
    @Binding var text: String
    @Binding var buttonPressed: Bool
    
    var label: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(label)
                        .font(.custom("Darker Grotesque", size: 14).weight(.bold))
                        .foregroundColor(Color.AppColors.secondary70DarkBlue)
                        .padding(.leading, 8)
                }
                
                TextField("", text: $text)
                    .font(.custom("Darker Grotesque", size: 14).weight(.bold))
                    .foregroundColor(Color.AppColors.secondary70DarkBlue)
                    .padding(.vertical, 14)
                    .padding(.leading, 10)
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1)
                    .foregroundColor(buttonPressed && text.isEmpty ? .AppColors.helperErrorRed : .black)
            )
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
        SinglelineTextField(text: $text, buttonPressed: $buttonPressed, label: "Insira seu nome")
        
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
