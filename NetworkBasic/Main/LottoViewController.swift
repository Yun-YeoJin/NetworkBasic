//
//  LottoViewController.swift
//  NetworkBasic
//
//  Created by 윤여진 on 2022/07/28.
//

import UIKit
//1. import 해주기
import Alamofire
import SwiftyJSON

class LottoViewController: UIViewController {
    
    
    @IBOutlet weak var numberTextField: UITextField!
    
    @IBOutlet var numberLabel: [UILabel]!
    
    @IBOutlet weak var bonusnumberLabel: UILabel!
    
    @IBOutlet weak var roundLabel: UILabel! {
        didSet {
            roundLabel.textAlignment = .center
        }
    }
    
    let userDefaults = UserDefaults.standard
    
    var lottoPickerView = UIPickerView() //인스턴스
    
    var numberList: [String] = []
    var reverseNumberArray: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        reverseNumberArray = Array(1...1027).reversed()
        lottoPickerView.delegate = self
        lottoPickerView.dataSource = self
        
        
        //텍스트필드 선택 되었을 때, pickerView 보여주기 (심는다)
        numberTextField.inputView = lottoPickerView
        numberTextField.tintColor = .clear
        numberTextField.textContentType = .oneTimeCode
        numberTextField.textAlignment = .center
        numberTextField.delegate = self
        
        requestLottoAPI(number: calculateDateForLotto()/7 + 1)
    }
    
    //MARK: DateComponents()로 만들기 -> 원하는 날짜 설정 -> date로 변환
    func calculateDateForLotto() -> Int {
        
        let today = Date()
        let calendar = Calendar.current
        
        var components = DateComponents() //로또가 처음 시작된 2002년 12월 7일 (1회차)
        components.day = 7
        components.month = 12
        components.year = 2002
        
        let startday = calendar.date(from: components)
        
        components = calendar.dateComponents([.day], from: startday!, to: today)
        
        return Int(components.day ?? 0)
    }
    
    func requestLottoAPI(number: Int) {
        
        if userDefaults.array(forKey: "\(number)") != nil {
            numberList = userDefaults.array(forKey: "\(number)") as! [String]
            
            for number in 0..<self.numberLabel.count {
                self.numberLabel[number].text = "\(self.numberList[number])"
            }
            self.bonusnumberLabel.text = "\(self.numberList[6])"
            self.numberTextField.text = self.numberList[7]
            self.roundLabel.text = "\(self.numberList[8])회차"
            
        } else {
            
            var roundArray: [String] = []
            let url = "\(EndPoint.lottoURL)&drwNo=\(number)"
            AF.request(url, method: .get).validate().responseData { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    
                    for number in 0...5 {
                        self.numberLabel[number].text = json["drwtNo\(number + 1)"].stringValue
                        roundArray.append(json["drwtNo\(number + 1)"].stringValue)
                    }
                    self.bonusnumberLabel.text = json["bnusNo"].stringValue
                    roundArray.append(json["bnusNo"].stringValue)
                    let date = json["drwNoDate"].stringValue
                    roundArray.append(date)
                    let round = json["drwNo"].intValue
                    roundArray.append(String(round))
                    
                    self.userDefaults.set(roundArray, forKey: "\(number)")
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
        
    }
}

extension LottoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // PickerView의 구성 요소 수
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // PickerView의 구성 요소의 행 수를 반환하는 함수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return reverseNumberArray.count
    }
    // PickerView의 지정된 구성 요소 행이 선택되었을 때
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        requestLottoAPI(number: reverseNumberArray[row])
    }
    // PickerView의 구성 요소 행의 이름
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(reverseNumberArray[row])회차"
    }
    
}

extension LottoViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        numberTextField.isUserInteractionEnabled = false
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        numberTextField.isUserInteractionEnabled = true
    }
}

