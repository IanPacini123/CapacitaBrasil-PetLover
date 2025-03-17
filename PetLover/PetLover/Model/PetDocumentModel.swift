//
//  PetDocumentModel.swift
//  PetLover
//
//  Created by Izadora Montenegro on 17/03/25.
//

import SwiftData
import Foundation

@Model
class PetDocument: Identifiable {
    var title: String
    var fileData: Data
    
    init(title: String = "", fileData: Data) {
        self.title = title
        self.fileData = fileData
    }
}
