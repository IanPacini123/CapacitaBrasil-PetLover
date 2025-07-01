//
//  IndicatorBar.swift
//  PetLover
//
//  Created by Izadora Montenegro on 11/03/25.
//

import SwiftUI

struct IndicatorBar: View {
    let numberOfPages: Int
    @Binding var currentPage: Int
    
    var body: some View {
        HStack {
            ForEach(0..<numberOfPages, id: \.self) { index in
                Circle()
                    .frame(width: currentPage == index ? 18 : 9, height: 9)
                    .foregroundColor(currentPage == index ? Color.AppColors.primary50Orange : .white)
                    .scaleEffect(currentPage == index ? 1.2 : 1.0)
                    .animation(.easeInOut, value: currentPage)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Color.AppColors.primary30Beige
        )
        .cornerRadius(20)
        .padding()
    }
}
