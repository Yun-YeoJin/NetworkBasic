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
    //MARK: 코드로 뷰를 만드는 기능이 훨씬 더 많이 남아있다!!!!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //텍스트필드 선택 되었을 때, pickerView 보여주기 (심는다)
        numberTextField.inputView = lottoPickerView
        numberTextField.tintColor = .clear
        
        lottoPickerView.delegate = self
        lottoPickerView.dataSource = self
        
    }
    
}

extension LottoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        numberTextField.text = "\(numberList[row])회차"
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numberList[row])회차"
    }
    
}
