//  diary_emotion_analysisApp.swift
//  diary_emotion_analysis
//  Created by 권소령 on 10/29/24.
//
import SwiftUI

struct DiaryView: View {
    @State private var diaryText: String="" // 사용자가 작성할 일기 내용을 저장하는 변수
    @State private var analysisResult: String? // 감정분석 결W과 표시할 변수
    @State private var diaryID: Int? // 저장된 다이어리 ID
    
    //---------------------UI 화면 디자인----------------------
    var body: some View{
        // NavigationView: 화면 간 전환을 관리하는 네비게이션 컨테이너
        NavigationView{
            VStack{
                Text("Today's diary")
                    .font(.largeTitle)
                    .bold()
                    .padding() // view의 상하좌우 간격을 잡아주는 padding
                
                TextEditor(text: $diaryText) // 일기 내용 작성하는 텍스트 에디터
                    .padding()
                    .border(Color.gray, width:3)
                    .frame(height:300)
                    .cornerRadius(5)
                
                //save button 누르면 saveDiary function 실행
                Button(action: saveDiary){
                    Text("Save")
                        .padding()
                        .bold()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                if let result = analysisResult{
                    Text("result of analysis emotions : \(result)")
                        .padding()
                }
                            
                    
            }
            .padding()
            // "기록 보기" 버튼 추가
            // NavigationLink : 특정 버튼을 클릭하면 DiaryListView로 화면이 전환되도록 설정
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    NavigationLink(destination: CalendarView()){
                        Text("History")
                            .padding(7)
                            .bold()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
        }
    }
    
    func saveDiary(){
        sendDiaryToServer(diaryText)
    }

// ---------------------------- 서버로 일기 전송하는 함수 ---------------------------------
    func sendDiaryToServer(_ diaryText: String){
        // 1. 서버 url 설정 : 일기 데이터를 서버에 보내기 위해 요청할 서버 URL을 문자열로 설정
        //애뮬레이터에서는 127.0.0.1이 아닌 local network IP(my pc ip)로 연결해야 함
        guard let url = URL(string:"\(Constants.baseURL)/analyze") else {return}
        
        // 2. HTTP 요청 객체 구성
        var request = URLRequest(url:url)
        request.httpMethod = "POST" // POST 요청 방식 사용
        // HTTP 요청 헤더에 "content-Type: application/json" 추가 => 서버에 전송할 데이터 JSON 형식임을 알림
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 3. create JSON data
        // optional binding 적용
        // 값이 필요없는 경우 let _ 를 사용해서 간단하게 처리 가능
        guard let jsonData = try? JSONSerialization.data(withJSONObject: ["diaryText":diaryText])else{
            print("Error creating JSON data")
            return
        }
        // 생성된 json 데이터를 http요청의 httpbody에 추가하여 전송 준비 완료
        request.httpBody = jsonData
        
        // 4. (비동기) 네트워킹 요청 수행
        // 서버 응답 도착 시, 콜백 함수 실행됨
        URLSession.shared.dataTask(with: request){ data, response, error in
            if let error = error{
                print("Error: ",error)
                return
            }
            
            guard let data = data else {return}
            
            // json parsing : 서버에서 수신된 감정 분석 결과 데이터를 swift dictionary로 반환
            if let responseDict = try? JSONSerialization.jsonObject(with: data) as? [String:Any]{
        // 5. 서버 응답 처리 및 화면 업데이트
                if let sentiment = responseDict["sentiment"] as? String,
                   let id = responseDict["diary_id"] as? Int{
                // 메인 스레드에서 UI 업데이트를 위한 Dispatch~~ 사용
                // swift 네트워크 요청은 비동기적으로 실행되므로 UI 업데이트는 메인 스레드에서 수행해야 함
                    DispatchQueue.main.async{
                        // 서버에서 반환된 감정 분석 결과 저장하는 변수
                        self.analysisResult = sentiment
                        self.diaryID = id
                    }
                } else{
                    print("Response keys not found: \(responseDict)")
                }
            } else{
                print("Failed to parse server response")
            }
        }.resume() // 비동기 테스크를 재개 하기 위해서 사용하는 함수
    }
}

#Preview {
    DiaryView()
}