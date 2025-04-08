//
//  SeletorInput.swift
//  PetLover
//
//  Created by Izadora Montenegro on 18/03/25.
//

import SwiftUI

struct SeletorInput: View {
    var label: String
    var action: () -> Void
    var body: some View {
        Button {
          action()
        } label: {
            HStack {
                Text(label)
                    .foregroundStyle(.black)
                    .appFontDarkerGrotesque(darkness: .Bold, size: 14)
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
                    .foregroundStyle(.black)
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    SeletorInput(label: "Qual o gênero do seu pet?", action: {
        print("Selecionar genero")
    })
}
