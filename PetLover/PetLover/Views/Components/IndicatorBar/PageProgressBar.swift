//
//  PageProgressBar.swift
//  PetLover
//
//  Created by Izadora Montenegro on 31/03/25.
//

import SwiftUI

struct PageProgressBar: View {
    let totalPages: Int
    let currentPage: Int
    
    private var progress: CGFloat {
        guard totalPages > 0 else { return 0 }
        return CGFloat(currentPage) / CGFloat(totalPages)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 3)
                    .foregroundColor(Color.AppColors.nearNeutralLight)
                
                RoundedRectangle(cornerRadius: 3)
                    .frame(width: geometry.size.width * progress)
                    .foregroundColor(Color.AppColors.secondary40Blue)
                    .animation(.easeInOut, value: currentPage)
            }
        }
        .frame(height: 10)
    }
}

#Preview {
    PageProgressBar(totalPages: 5, currentPage: 2)
        .padding(.horizontal, 56)
}


