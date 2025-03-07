//
//  CalenderView.swift
//  diary_emotion_analysis
//
//  Created by 권소령 on 2/10/25.
// 전체적인 캘린더 페이지를 담당하는 부모 뷰
//
import SwiftUI


struct CalendarView: View {
    @State private var selectedDate = Date() //현재 선택된 날짜
    @State private var diaryEntries: [DiaryEntry] = [] // 서버에서 받아올 일기 목록
    @State private var selectedDiaryDate:String = "" // 선택한 날짜("yyyy-MM-dd" 형색)
    
    
    var body: some View{
        VStack{
            Text("Diary Calendar")
                .font(.largeTitle)
                .bold()
                .padding()

            // 캘린더 표시 (현재 달) -> 자식 뷰를 사용하여 캘린더 표시
            CalendarGridView(selectedDate: $selectedDate, diaryEntries: diaryEntries, onSelectDate: { date in
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                selectedDiaryDate = formatter.string(from: date)
                // 선택한 날짜의 데이터 가져오기
                fetchDiaryEntries(for: selectedDiaryDate)
                })
            
            // 선택한 날짜의 일기 목록
            if !selectedDiaryDate.isEmpty{
                Text("\(selectedDiaryDate)")
                    .font(.title2)
                    .padding()
                List{
                    ForEach(diaryEntries){ entry in
                        HStack{
                            VStack(alignment: .leading){
                                Text(entry.createdAt)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text(entry.text)
                                .font(.body)
                                Text("Sentiment: \(entry.sentiment)")
                                .font(.footnote)
                                .foregroundColor(getColor(for: entry.sentiment))
                            }
                            Spacer()
                        }
                        .padding()
                    }
                    .onDelete(perform: deleteItem)
                }
            }
        }
        .onAppear{
            fetchDiaryEntries(for: selectedDiaryDate) // 초기 데이터 로드
        }
    }
    
 //감정에 따른 색상 변환 함수
    func getColor(for sentiment: String) -> Color{
        switch sentiment.uppercased(){
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

    // 서버에서 선택된 날짜의 일기 데이터만 가져오는 함수
func fetchDiaryEntries(for date: String) {
    guard !date.isEmpty,
          let encodedDate = date.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
          let url = URL(string: "\(Constants.baseURL)/diary_entries/\(encodedDate)/") else {
        print("Invalid URL")
        return }


        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching diary entries: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return }

            // Decoding the json data
            do{
                let decodedResponse = try JSONDecoder().decode([DiaryEntry].self, from: data)
                DispatchQueue.main.async {
                    self.diaryEntries = decodedResponse
                }
            } catch {
                 print("Decoding error : \(error)")
            }
        }.resume()
    }

    // 서버로 삭제 요청을 보내는 함수
    func deleteDiaryEntry(_ id: Int){
        guard let url = URL(string: "\(Constants.baseURL)/diary_entries/delete/\(id)/") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        // 오청이 DELETE인지 로그 확인
        print("Sending DELETE request to: \(url.absoluteString)")

        URLSession.shared.dataTask(with: request){ data, response, error in
            if let error = error{
                print("Error deleting diary entry: \(error)")
                return
            }
            // HTTP 응답 코드 확인
            if let httpResponse = response as? HTTPURLResponse{
                print("Response status code: \(httpResponse.statusCode)")
            }
            DispatchQueue.main.async{
                // 삭제 성공 시 리스트에서 해당 항목 제거
                diaryEntries.removeAll{ $0.id==id }
            }
        }.resume()
    }

    // SwiftUI의 삭제 기능 연결
    func deleteItem(at offsets: IndexSet){
        for index in offsets{
            let entry = diaryEntries[index]
            deleteDiaryEntry(entry.id)
        }
    }
}

struct DiaryEntry: Identifiable, Codable {
    let id: Int
    let text: String
    let sentiment: String
    let createdAt: String

    //JSON key와 Swift 속성을 매핑
    enum CodingKeys: String, CodingKey{
        case id
        case text
        case sentiment
        case createdAt = "created_at"
    }
}


#Preview {
    CalendarView()
}
