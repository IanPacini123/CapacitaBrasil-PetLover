//
//  FontExtension.swift
//  PetLover
//
//  Created by Ian Pacini on 11/03/25.
//

import SwiftUI

extension Font {
    enum DarkerGrotesqueFontTypes: String {
        case Regular = "DarkerGrotesque-Light_Regular"
        case Light = "DarkerGrotesque-Light"
        case Medium = "DarkerGrotesque-Light_Medium"
        case SemiBold = "DarkerGrotesque-Light_SemiBold"
        case Bold = "DarkerGrotesque-Light_Bold"
        case ExtraBold = "DarkerGrotesque-Light_ExtraBold"
        case Black = "DarkerGrotesque-Light_Black"
    }
    
    static func appFontDarkerGrotesque(darkness: Font.DarkerGrotesqueFontTypes, size: CGFloat) -> Font {
        return Font.custom(darkness.rawValue, size: size)
    }
}
