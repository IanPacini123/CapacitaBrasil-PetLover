//
//  PetFormHeader.swift
//  PetLover
//
//  Created by Izadora Montenegro on 22/04/25.
//

import SwiftUI

struct PetFormHeader: View {
    @State var title: String
    @State var text: String
    @State var totalPages: Int
    @State var currentPage: Int
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(title)
                .appFontDarkerGrotesque(darkness: .SemiBold, size: 24)
            Text(text)
                .appFontDarkerGrotesque(darkness: .Regular, size: 17)
                .multilineTextAlignment(.center)
            PageProgressBar(totalPages: totalPages, currentPage: currentPage)
                .padding(.horizontal, 70)
                .padding(.top, 8)
        }
    }
}
