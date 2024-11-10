//
//  diary_emotion_analysisApp.swift
//  diary_emotion_analysis
//
//  Created by 권소령 on 10/29/24.
//
import SwiftUI

struct DiaryView: View {
    //@State ?
    @State private var diaryText: String = "" // 사용자가 작성할 일기 내용 저장하는 변수
    @State private var analysisResult: String? //감정분석 결과 표시할 변수
    
    var body: some View{
        VStack{
            Text("Today's diary")
                .font(.largeTitle)
                .bold()
                .padding() // view의 상하좌우 간격을 잡아주는 padding
            
            TextEditor(text: $diaryText) // 일기 내용 작성하는 텍스트 에디터
                .padding()
                .border(Color.gray, width:2)
                .frame(height:300)
            
            Button(action: saveDiary){
                Text("save")
                    .padding()
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
    }
    func saveDiary(){
        sendDiaryToServer(diaryText)
    }

    func sendDiaryToServer(_ diaryText: String){
        //서버 url 설정
        guard let url = URL(string:"http://127.0.0.1:8000/analyze") else {return}
        
        // 요청 설정
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "content-Type")
        
        // create JSON data(이건 왜 하는 거임)
        // optional binding 적용
        // 값이 필요없는 경우 let _ 를 사용해서 간단하게 처리 가능
        guard let jsonData = try? JSONSerialization.data(withJSONObject: ["diaryText":diaryText])else{
            print("Error creating JSON data")
            return
        }
    
        request.httpBody = jsonData
        
        // 네트워킹 요청 시작
        URLSession.shared.dataTask(with: request){ data, response, error in
            if let error = error{
                print("Error: ",error)
                return
            }
            
            guard let data = data else {return}
            
            // 서버에서 받은 감정 분석 결과 parsing
            if let responseDict = try? JSONSerialization.jsonObject(with: data) as? [String:String],
               let sentiment = responseDict["sentiment"]{
                DispatchQueue.main.async{
                    // 서버에서 반환된 감정 분석 결과 저장하는 변수
                    self.analysisResult = sentiment
                }
            }
        }.resume()
    }
}


#Preview {
    DiaryView()
}
