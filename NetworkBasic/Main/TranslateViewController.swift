//
//  TranslateViewController.swift
//  NetworkBasic
//
//  Created by 윤여진 on 2022/07/28.
//

import UIKit

import Alamofire
import SwiftyJSON

//UIButton, UITextField -> @IBAction
//UITextView, UISearchBar, UIPickerView -> 액션 불가
//UIResponderChain >

class TranslateViewController: UIViewController {
    
    @IBOutlet weak var userInputTextView: UITextView!
    
    let textViewPlaceholderText = "번역하고 싶은 문장을 작성해보세요."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userInputTextView.delegate = self //위 텍스트뷰에만 delegate = self로 연결이 되어있기 때문에.
        
        userInputTextView.text = textViewPlaceholderText
        userInputTextView.textColor = .opaqueSeparator
        
        userInputTextView.font = UIFont(name: "DalseoHealingMedium", size: 15)
        
        requestTranslate()
    }
    
    // MARK: POST 방식
    func requestTranslate() {
        
        let url = EndPoint.translateURL
        
        let header: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]
        
        let parameter = ["source": "ko","target": "en","text": "안녕하세요 저는 과자를 좋아합니다."]
        
        AF.request(url, method: .post, parameters: parameter, headers: header).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let statusCode = response.response?.statusCode ?? 500
                
                if statusCode == 200 {
                    let translateMessage = json["message"]["result"]["translatedText"].string
                    self.userInputTextView.text = translateMessage
                } else {
                    self.userInputTextView.text = json["errorMessage"].stringValue
                }
                
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension TranslateViewController: UITextViewDelegate {
    
    // 텍스트뷰의 텍스트가 변할 때마다 호출
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text.count)
    }
    // 커서가 시작될 때, 편집이 시작될 때 (커서 깜빡일 때)
    // 텍스트뷰 글자 : 플레이스 홀더랑 글자가 같으면 clear, color
    func textViewDidBeginEditing(_ textView: UITextView) {
        // print("변경이 시작됩니다.")
        if textView.textColor == .opaqueSeparator {
            textView.text = nil
            textView.textColor = .black
        }
    }
    // 편집이 끝났을 때, 커서가 없어지는 순간
    // 텍스트뷰 글자: 사용자가 아무 글자도 안 썼으면 플레이스 홀더 글자 보이게 해라!
    func textViewDidEndEditing(_ textView: UITextView) {
        // print("변경이 끝났습니다.")
        if textView.text.isEmpty {
            textView.text = textViewPlaceholderText
            textView.textColor = .opaqueSeparator
        }
    }
}
