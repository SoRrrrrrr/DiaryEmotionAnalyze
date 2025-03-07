//
//  CalendarGridView.swift
//  diary_emotion_analysis
//
//  Created by 권소령 on 2/10/25.
// 날짜를 Grid로 표시하는 자식 뷰(Child View)
//----------------------- 감정 색상 하이라이트 적용 -------------------------

import SwiftUI

struct CalendarGridView: View {
    @Binding var selectedDate: Date
    var diaryEntries: [DiaryEntry]
    var onSelectDate: (Date) -> Void // 날짜 선택 시 실행할 함수
    
    private let daysInWeek = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
    
    var body: some View {
        VStack{
            // 요일 헤더 표시
            HStack{
                ForEach(daysInWeek, id:\.self){ day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .font(.headline)
                }
            }
        
        //날짜별 그리드 표시
        let days = getDaysForCurrentMonth()
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 20){
                ForEach(days, id: \.self) { date in
                    if let date = date {
                        let emotionColor = getColor(for: date)
                        Text("\(Calendar.current.component(.day, from: date))")
                            .frame(width: 35, height: 35)
                            .background(emotionColor)
                            .clipShape(Circle())
                            .onTapGesture{
                                onSelectDate(date) // 날짜 선택 시 부모 뷰로 전달
                            }
                    } else {
                        Text("")
                            .frame(width: 35, height: 40) // 빈공간 정렬 유지
                    }
                }
            }
        }.padding()
    }
    
    // 현재 달의 날짜 가져오기
    func getDaysForCurrentMonth() -> [Date?]{
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: selectedDate)
        let currentYear = calendar.component(.year, from: selectedDate)
        let firstDayOfMonth = calendar.date(from: DateComponents(year: currentYear, month: currentMonth, day: 1))!
        let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth)!
        
        var days: [Date?] = Array(repeating: nil, count: calendar.component(.weekday, from: firstDayOfMonth) - 1)
        days += range.map { calendar.date(from: DateComponents(year: currentYear, month: currentMonth, day: $0)) }
        return days
    }
    
    // 감정 분석 결과에 따른 색상 변환
    func getColor(for date: Date) -> Color{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        
        if let entry = diaryEntries.first(where: {$0.createdAt.starts(with: dateString) })
        {
            switch entry.sentiment.uppercased(){
            case "ANGER":
                return .red
            case "JOY":
                return .yellow
            case "SADNESS":
                return .blue
            case "SURPRISE":
                return .purple
            case "FEAR":
                return .orange
            case "LOVE":
                return .pink
            default:
                return .teal
            }
        }
        return .clear
    }
}
