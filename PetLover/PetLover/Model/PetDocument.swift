//
//  PetDocument.swift
//  PetLover
//
//  Created by Izadora Montenegro on 18/03/25.
//

import SwiftData
import Foundation

@Model
class PetDocument: Identifiable {
    var title: String
    var fileURL: URL
    
    init(title: String = "", fileURL: URL) {
        self.title = title
        self.fileURL = fileURL
    }
}

