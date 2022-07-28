//
//  ViewPresentableProtocol.swift
//  NetworkBasic
//
//  Created by 윤여진 on 2022/07/28.
//

/*
 -----Protocol
 -----Delegate
 */

import UIKit
import Foundation

// 책에서 목차를 빼듯이, naming만 빼서 protocol에 넣는다.
//MARK: 프로토콜은 규약이자 필요한 요소를 명시만 할 뿐, 실질적인 구현부는 작성하지 않는다.
//실직적인 구현은 프로토콜을 채택(준수)한 타입이 구현한다.
//클래스, 구조체, 익스텐션, 열거형 등 사용 가능
// @objc optional -> 선택적 요청(Optional Requirement)
@objc protocol ViewPresentableProtocol {
    
    //프로토콜 프로퍼티: 연산 프로퍼티로 쓰든 저장 프로퍼티로 쓰든 상관하지 않음.
    //명시하지 않기에, 구현을 할 때 프로퍼티를 저장/연산 프로퍼티로 사용 가능하다.
    //무조건 variable로 선언해야 한다.
    var navigationTitleString: String { get set } // 읽기, 쓰기 전용으로 만들겠다
    var backgroundColor: UIColor { get }
    static var identifier: String { get }
    //만약 get만 명시했다면, get 기능만 최소한 구현되어 있으면 된다.그래서 필요하다면 set도 구현해도 괜찮다.
    
    func configureView() //뷰적인 레이아웃
    @objc optional func configureLabel() // 레이블의 레이아웃
    @objc optional func configureTextField()
} // 클래스는 단일 상속, 프로토콜은 채택 갯수에 제한이 없다!

/*
 EX) TableView
 */

@objc protocol YUNTableViewProtocol {
    func numberOfRowsInsection() -> Int
    func cellForRowAt(indexpath: IndexPath) -> UITableViewCell
    @objc optional func didSelectRowAt()
}
