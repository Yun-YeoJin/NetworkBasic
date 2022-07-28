//
//  LottoViewController.swift
//  NetworkBasic
//
//  Created by 윤여진 on 2022/07/28.
//

import UIKit

class LottoViewController: UIViewController {
    
    let numberList: [Int] = Array(1...1025).reversed()
    
    @IBOutlet weak var numberTextField: UITextField!
    
//    @IBOutlet weak var lottoPickerView: UIPickerView!
    
    var lottoPickerView = UIPickerView() //인스턴스
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lottoPickerView.delegate = self
        lottoPickerView.dataSource = self
        
        
        
        
        //텍스트필드 선택 되었을 때, pickerView 보여주기 (심는다)
        numberTextField.inputView = lottoPickerView
        numberTextField.tintColor = .clear
        
       
        
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
        numberTextField.text = "\(numberList[row])회차"
    }
    // PickerView의 구성 요소 행의 이름
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numberList[row])회차"
    }
    
}
