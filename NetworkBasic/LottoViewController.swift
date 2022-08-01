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
    
    let numberList: [Int] = Array(1...1025).reversed()
    
    @IBOutlet weak var numberTextField: UITextField!
    
    //@IBOutlet weak var lottoPickerView: UIPickerView!
    
    var lottoPickerView = UIPickerView() //인스턴스
    
    @IBOutlet weak var firstNumberLabel: UILabel!
    @IBOutlet weak var secondNumberLabel: UILabel!
    @IBOutlet weak var thirdNumberLabel: UILabel!
    @IBOutlet weak var fourthNumberLabel: UILabel!
    @IBOutlet weak var fifthNumberLabel: UILabel!
    @IBOutlet weak var sixthNumberLabel: UILabel!
    @IBOutlet weak var bonusNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lottoPickerView.delegate = self
        lottoPickerView.dataSource = self
        
        
        //텍스트필드 선택 되었을 때, pickerView 보여주기 (심는다)
        numberTextField.inputView = lottoPickerView
        numberTextField.tintColor = .clear
        numberTextField.textContentType = .oneTimeCode
        
    }
    
    func requestLottoAPI(number: Int) {
        
        //AF: 200-299 status Code
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(number)"
        
        AF.request(url, method: .get).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let firstNumber = json["drwtNo1"].stringValue
                self.firstNumberLabel.text = firstNumber
                let secondNumber = json["drwtNo2"].stringValue
                self.secondNumberLabel.text = secondNumber
                let thirdNumber = json["drwtNo3"].stringValue
                self.thirdNumberLabel.text = thirdNumber
                let fourthNumber = json["drwtNo4"].stringValue
                self.fourthNumberLabel.text = fourthNumber
                let fifthNumber = json["drwtNo5"].stringValue
                self.fifthNumberLabel.text = fifthNumber
                let sixthNumber = json["drwtNo6"].stringValue
                self.sixthNumberLabel.text = sixthNumber
                let bonusNumber = json["bnusNo"].stringValue
                self.bonusNumberLabel.text = bonusNumber
             
                
                let date = json["drwNoDate"].stringValue
                print(date)
                
                self.numberTextField.text = date
                self.numberTextField.textAlignment = .center
                
                case .failure(let error):
                print(error)
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
        return numberList.count
    }
    // PickerView의 지정된 구성 요소 행이 선택되었을 때
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        requestLottoAPI(number: numberList[row])
        // numberTextField.text = "\(numberList[row])회차"
    }
    // PickerView의 구성 요소 행의 이름
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numberList[row])회차"
    }
    
}
