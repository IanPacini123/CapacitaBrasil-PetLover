//
//  TextExtension.swift
//  PetLover
//
//  Created by Ian Pacini on 11/03/25.
//

import SwiftUI

extension Text {
    func appFontDarkerGrotesque(darkness: Font.DarkerGrotesqueFontTypes, size: CGFloat) -> Text {
        return self.font(.custom(darkness.rawValue, size: size))
    }
}
