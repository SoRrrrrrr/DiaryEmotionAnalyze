//
//  ContentView.swift
//  diary_emotion_analysis
//
//  Created by 권소령 on 10/29/24.
//  이건 걍 처음 시험 삼아 해본 파일이었던 거 같음
import SwiftUI // 최신 UI framework
import WebKit // 웹 콘텐츠를 앱에 표시하기 위해 제공하는 프레임워크

struct WebView: UIViewRepresentable{
    // 웹 페이지를 불러올 URL을 url 변수에 저장
    let url:URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url:url)
        uiView.load(request)
    }
}
struct ContentView: View {
    var body: some View {
        WebView(url:Bundle.main.url(forResource:"index", withExtension: "html")!).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
    }
}

//#Preview {
//    ContentView()
//}
