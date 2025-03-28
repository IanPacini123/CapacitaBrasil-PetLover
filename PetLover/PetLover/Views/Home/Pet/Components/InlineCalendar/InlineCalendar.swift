//
//  InlineCalendar.swift
//  PetLover
//
//  Created by Ian Pacini on 27/03/25.
//

import SwiftUI

struct InlineCalendar: View {
    @State var selectedDate = Date.now

    var dates: [Date] {
        let today = Date()
        var sequence = DateSequence(start: today, value: -1) // Datas para trás
        let pastDates = Array(sequence.prefix(365))
        
        sequence = DateSequence(start: today, value: 1) // Datas para frente
        let futureDates = Array(sequence.prefix(365))
        
        return pastDates.reversed() + [today] + futureDates
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                LazyHGrid(rows: [.init()], spacing: 12) {
                    ForEach(Array(dates.enumerated()), id: \.element) { index, day  in
                        Button {
                            selectedDate = day
                        } label: {
                            DayInlineCalendar(date: day)
                                .selected(selectedDate.formatted(.dateTime .day()) == day.formatted(.dateTime .day()))
                        }
                        .id(day.formatted(.dateTime .day()))
                    }
                }
            }
            .onAppear {
//                if let today = dates.first(where: { Calendar.current.isDate($0, inSameDayAs: Date()) }) {
//                    proxy.scrollTo(today, anchor: .leading)
//                }
                proxy.scrollTo(Date.now.formatted(.dateTime .day()), anchor: .leading)
            }
        }
    }
}

#Preview {
    InlineCalendar()
}

struct DateSequence: Sequence, IteratorProtocol {
    private var currentDate: Date
    private let calendar: Calendar
    private let component: Calendar.Component
    private let value: Int

    init(start: Date = Date(), calendar: Calendar = .current, component: Calendar.Component = .day, value: Int = 1) {
        self.currentDate = start
        self.calendar = calendar
        self.component = component
        self.value = value
    }

    mutating func next() -> Date? {
        defer { currentDate = calendar.date(byAdding: component, value: value, to: currentDate) ?? currentDate }
        return currentDate
    }
}
