//
//  Constant.swift
//  NetworkBasic
//
//  Created by 윤여진 on 2022/08/01.
//

import Foundation
import UIKit

// enum StoryboardName: String {
//    case main = "Main"
//    case select = "Select"
//    case detail = "Detail"
//    case setting = "Setting"
//    case name = "Name"
// }

struct StoryboardName {
    
    //접근 제어를 통한 초기화 방지
    
   private init() {
        
    }
    
    static let main = "Main"
    static let search = "Search"
    static let setting = "Setting"
}

/*
 1. Struct vs Enum => 인스턴스 생성 방지
 2. enum case vs enum static => case는 같은 내용을 못넣는다. static let으로 중복된 내용을 넣어줄 수 있다.
 */

enum storyboardName { //MARK: enum으로 생성시 인스턴스 생성 방지 가능.
    // var nickname = "고래밥" //인스턴스 프로퍼티를 못만든다.
    static let main = "Main" // 타입 프로퍼티는 가능
}

enum FontName {
    static let title = "SanFransico"
    static let body = "SanFransico"
    static let caption = "AppleSandol"
}
