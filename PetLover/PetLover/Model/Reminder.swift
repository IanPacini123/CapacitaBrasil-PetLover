//
//  Reminder.swift
//  PetLover
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 03/04/25.
//

import SwiftData
import Foundation

@Model
class Reminder: Identifiable {
    var id: UUID
    var petId: UUID
    var title: String
    var date: Date
    var category: ReminderCategory
    var repeatDays: Set<WeekDays>
    var startTime: Date
    var endTime: Date?
    var isCompleted: Bool
    
    init(
        petId: UUID,
        title: String,
        date: Date,
        category: ReminderCategory,
        repeatDays: Set<WeekDays> = [],
        startTime: Date,
        endTime: Date? = nil,
        isCompleted: Bool = false
    ){
        self.id = UUID()
        self.petId = petId
        self.title = title
        self.date = date
        self.category = category
        self.repeatDays = repeatDays
        self.startTime = startTime
        self.endTime = endTime
        self.isCompleted = isCompleted
    }
}

enum WeekDays: String, Codable, CaseIterable {
    case domingo, segunda, terca, quarta, quinta, sexta, sabado

    var displayText: String {
        switch self {
        case .domingo: return "D"
        case .segunda: return "S"
        case .terca: return "T"
        case .quarta: return "Q"
        case .quinta: return "Q"
        case .sexta: return "S"
        case .sabado: return "S"
        }
    }
}

enum ReminderCategory: String, Codable, CaseIterable {
    case eventos, saude, cuidadosDiarios
    
    var displayText: String {
        switch self {
        case .eventos: return "Eventos"
        case .saude: return "Saúde"
        case .cuidadosDiarios: return "Cuidados Diários"
        }
    }
}

