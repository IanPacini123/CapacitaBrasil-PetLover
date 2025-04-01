//
//  InlineCalendar.swift
//  PetLover
//
//  Created by Ian Pacini on 27/03/25.
//

import SwiftUI

struct InlineCalendar: View {
    @State var selectedDate = Date.now

    private var dates: [Date] {
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            
            let pastDates = (1...365).compactMap { calendar.date(byAdding: .day, value: -$0, to: today) }
            let futureDates = (1...365).compactMap { calendar.date(byAdding: .day, value: $0, to: today) }
            
        return pastDates.reversed() + [today] + futureDates
        }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [.init()], spacing: 12) {
                    ForEach(Array(dates.enumerated()), id: \.element) { index, day  in
                        Button {
                            selectedDate = day
                        } label: {
                            DayInlineCalendar(date: day)
                                .selected(selectedDate.asUniqueString() == day.asUniqueString())
                        }
                        .id(day.asUniqueString())
                    }
                }
            }
            .onAppear {
                if dates.first(where: { Calendar.current.isDate($0, inSameDayAs: Date()) }) != nil {
                    proxy.scrollTo(Date.now.asUniqueString(), anchor: .init(x: 0.005, y: 0.5))
                }
            }
        }
    }
}

#Preview {
    InlineCalendar()
}

private struct DateSequence: Sequence, IteratorProtocol {
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

private extension Date {
    func asUniqueString() -> String {
        return self.formatted(.iso8601 .day() .month() .year())
    }
}
