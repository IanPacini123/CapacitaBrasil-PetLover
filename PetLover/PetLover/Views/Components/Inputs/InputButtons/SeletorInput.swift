//
//  SeletorInput.swift
//  PetLover
//
//  Created by Izadora Montenegro on 18/03/25.
//

import SwiftUI

struct SeletorInput: View {
    var vazio: Bool = false
    @Binding var buttonPressed: Bool
    @State var isOptional: Bool
    var label: String
    var action: () -> Void
    @State var fieldTitle: String
    
    var body: some View {
        Button {
          action()
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                Text(fieldTitle)
                    .appFontDarkerGrotesque(darkness: .ExtraBold, size: 19)
                    .foregroundStyle(.black)
                    .padding(.leading)
                VStack(alignment: .leading) {
                    HStack {
                        Text(label)
                            .foregroundStyle(.black)
                            .appFontDarkerGrotesque(darkness: .Medium, size: 14)
                            .foregroundStyle(Color.AppColors.secondary70DarkBlue)
                            .padding(.vertical, 14)
                            .padding(.leading, 10)
                        Spacer()
                        Image("IconChevronRight")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                            .foregroundStyle(Color.AppColors.secondary70DarkBlue)
                            .padding()
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1)
                            .foregroundStyle((buttonPressed && !isOptional) && vazio ? .AppColors.helperErrorRed : Color.black)
                    }
                    .padding(.horizontal)
                    
                    if (buttonPressed && !isOptional) && vazio {
                        Text("Campo obrigatório. Selecione antes de continuar.")
                            .font(.custom("Darker Grotesque", size: 14).weight(.medium))
                            .foregroundColor(Color.AppColors.helperErrorRed)
                            .padding(.leading)
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var buttonPressed: Bool = false
    SeletorInput(buttonPressed: $buttonPressed, isOptional: false, label: "Qual o gênero do seu pet?", action: {
        print("Selecionar genero")
    }, fieldTitle: "Gênero")
}
