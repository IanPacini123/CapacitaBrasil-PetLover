//
//  ModalLembrete.swift
//  PetLover
//
//  Created by Izadora Montenegro on 30/04/25.
//

import SwiftUI

struct ModalLembrete: View {
    @State var selectedDays: Set<WeekDays> = []
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 65) {
                Image("IconPlus")
                    .rotationEffect(Angle(radians: 45.0))
                
                Text("Lembrete")
                .appFontDarkerGrotesque(darkness: .Black, size: 32)
                
                Image("IconMenu")
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 14)
            
            VStack(alignment: .leading) {
                Text("Vacina raiva")
                .appFontDarkerGrotesque(darkness: .Black, size: 32)
                
                HStack {
                    Image("IconClock")
                    Text("12 AM")
                        .appFontDarkerGrotesque(darkness: .Medium, size: 19)
                }
                
                HStack {
                    Image("IconCalendar")
                    Text("06/12/2004")
                        .appFontDarkerGrotesque(darkness: .Medium, size: 19)
                }
                
                Divider()
                    .background(Color.AppColors.nearNeutralLightLightGray)
                
                Text("Categoria")
                    .appFontDarkerGrotesque(darkness: .ExtraBold, size: 19)
                
                // foreach
                Text("Saúde")
                    .appFontDarkerGrotesque(darkness: .Bold, size: 17)
                    .foregroundStyle(Color.AppColors.nearNeutralLightLightGray)
                    .padding(.horizontal, 25)
                    .padding(.vertical, 12)
                    .background(
                        Color.AppColors.secondary40Blue
                    )
                    .cornerRadius(8)
                
                ReminderRepeaterList(selectedDays: $selectedDays)
            }
        }
    }
}

#Preview {
    ModalLembrete()
        .padding()
}
