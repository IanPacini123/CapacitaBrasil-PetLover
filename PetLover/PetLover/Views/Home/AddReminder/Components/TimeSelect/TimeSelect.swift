//
//  TimeSelect.swift
//  PetLover
//
//  Created by Ian Pacini on 01/04/25.
//

import SwiftUI

struct TimeSelect: View {
    @State private var startDate: Date
    @State private var endDate: Date
    
    @Binding var userStartDate: Date
    @Binding var userEndDate: Date
    
    @State var startTimeOfDay: TimeOfDay = .AM
    @State var endTimeOfDay: TimeOfDay = .AM

    init(startingDate: Binding<Date>, endingDate: Binding<Date>) {
        self._userStartDate = startingDate
        self._userEndDate = endingDate

        _startDate = State(initialValue: startingDate.wrappedValue)
        _endDate = State(initialValue: endingDate.wrappedValue)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            createRow(
                title: "Início",
                date: $startDate,
                timeOfDay: $startTimeOfDay,
                dateRange: getDateRange()
            )
            .padding(.bottom, 12)

            createRow(
                title: "Fim",
                date: $endDate,
                timeOfDay: $endTimeOfDay,
                dateRange: getDateRange(startDate: startDate,
                                        startTimeOfDay: startTimeOfDay,
                                        endTimeOfDay: endTimeOfDay)
            )

            
        }
        .onChange(of: startDate) { oldValue, newValue in
            if startDate > endDate {
                withAnimation(.easeInOut) {
                    endDate = startDate
                }
            }
            updateUserDates()
        }
        .onChange(of: endDate) { oldValue, newValue in
            if startDate > endDate && startTimeOfDay == endTimeOfDay {
                withAnimation(.easeInOut) {
                    endDate = startDate
                }
            }
            updateUserDates()
        }
        .onChange(of: startTimeOfDay) { oldValue, newValue in
            if startTimeOfDay == .PM && endTimeOfDay == .AM {
                withAnimation(.easeInOut) {
                    endTimeOfDay = .PM
                }
            }
            updateUserDates()
        }
        .onChange(of: endTimeOfDay) { oldValue, newValue in
            if startTimeOfDay == .PM && endTimeOfDay == .AM {
                withAnimation(.easeInOut) {
                    startTimeOfDay = .AM
                }
            }
            updateUserDates()
        }
    }
    
    @ViewBuilder private func createRow(title: String, date: Binding<Date>, timeOfDay: Binding<TimeOfDay>, dateRange: ClosedRange<Date>) -> some View {
        HStack {
            Text(title)
            
            Spacer()
            
            Text(date.wrappedValue.formatted(.dateTime .hour() .minute()))
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .foregroundStyle(.black)
                .font(.appFontDarkerGrotesque(darkness: .SemiBold, size: 22))
                .background {
                    reusableBG
                }
                .overlay {
                    DatePicker("",
                               selection: date,
                               in: dateRange,
                               displayedComponents: .hourAndMinute)
                        .foregroundStyle(.black)
                        .font(.appFontDarkerGrotesque(darkness: .SemiBold, size: 22))
                        .blendMode(.destinationOver)
                }
            
            AMPMSelector(timeOfDay: timeOfDay.wrappedValue)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        timeOfDay.wrappedValue.toggle()
                    }
                }
        }
    }
    
    @ViewBuilder private func AMPMSelector(timeOfDay: TimeOfDay) -> some View {
        HStack {
            Text("AM")
                .foregroundStyle(timeOfDay.rawValue == "AM" ? .white : .black)
                .padding(.horizontal, 20)
                .padding(.vertical, 6)
            
            Text("PM")
                .foregroundStyle(timeOfDay.rawValue == "PM" ? .white : .black)
                .padding(.horizontal, 20)
                .padding(.vertical, 6)
        }
        .font(.appFontDarkerGrotesque(darkness: .SemiBold, size: 22))
        .background {
            HStack {
                if timeOfDay == .PM {
                    Color.clear
                }
                
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(Color.AppColors.primary50Orange)
                
                if timeOfDay == .AM {
                    Color.clear
                }
            }
        }
        .padding(2)
        .background {
            reusableBG
        }
    }
    
    private var reusableBG: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundStyle(Color.AppColors.lightGrayButtonBackground)
            .overlay {
                Color.black
                    .clipShape(RoundedRectangle(cornerRadius: 10).stroke())
                
            }
    }
    
    private func getDateRange(
        startDate: Date? = nil,
        startTimeOfDay: TimeOfDay? = nil,
        endTimeOfDay: TimeOfDay? = nil
    ) -> ClosedRange<Date> {
        
        let calendar = Calendar.current
        let now = Date()
        
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: now)
        
        guard let fixedStart = calendar.date(from: DateComponents(
            year: todayComponents.year,
            month: todayComponents.month,
            day: todayComponents.day,
            hour: 1,
            minute: 0
        )),
        let fixedEnd = calendar.date(from: DateComponents(
            year: todayComponents.year,
            month: todayComponents.month,
            day: todayComponents.day,
            hour: 12,
            minute: 0
        )) else {
            fatalError("Falha ao criar datas fixas")
        }
        
        guard let endTimeOfDay = endTimeOfDay, let startTimeOfDay = startTimeOfDay else {
            return fixedStart...fixedEnd
        }
        
        let start = startDate ?? fixedStart
        
        if startTimeOfDay == .PM {
            if start < fixedEnd {
                return start...fixedEnd
            }
            return fixedStart...fixedEnd
        } else if endTimeOfDay == .PM {
            return fixedStart...fixedEnd
        } else {
            let safeStart = min(start, fixedEnd)
            
            return safeStart...fixedEnd
        }
    }

    private func updateUserDates() {
        if startTimeOfDay == .PM {
            userStartDate = startDate.addingTimeInterval(3600 * 12)
            userEndDate = endDate.addingTimeInterval(3600 * 12)
        } else if endTimeOfDay == .PM {
            userStartDate = startDate
            userEndDate = endDate.addingTimeInterval(3600 * 12)
        } else {
            userStartDate = startDate
            userEndDate = endDate
        }
    }
}

private struct previewStruct: View {
    @State var startDate = Date.now
    @State var endDate = Date.now
    
    var body: some View {
        VStack {
            TimeSelect(startingDate: $startDate, endingDate: $endDate)
            
            Group {
                Text(startDate.formatted(.dateTime .day() .month() .year() .hour() . minute()))
                Text(endDate.formatted(.dateTime .day() .month() .year() .hour() . minute()))
            }
            .font(.appFontDarkerGrotesque(darkness: .SemiBold, size: 30))
        }
    }
}

#Preview {
    previewStruct()
        .padding()
}

enum TimeOfDay: String {
    case AM, PM
    
    mutating func toggle() {
        switch self {
        case .AM:
            self = .PM
        case .PM:
            self = .AM
        }
    }
}
