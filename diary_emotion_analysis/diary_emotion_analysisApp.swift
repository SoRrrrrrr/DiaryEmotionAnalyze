//
//  diary_emotion_analysisApp.swift
//  diary_emotion_analysis
//
//  Created by 권소령 on 10/29/24.
//
import SwiftUI
import Foundation
//진입점 파일
@main
struct diary_emotion_analysisApp:App{
    var body: some Scene{
        WindowGroup{
            // DiaryView.swift는 일기 작성 화면을 보여주는 뷰이므로, 앱 진입점에서는 DiaryView를 호출해야 함
            DiaryView() //첫 화면을 DiaryView로 설정
        }
    }
}
