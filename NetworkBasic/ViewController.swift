//
//  ViewController.swift
//  NetworkBasic
//
//  Created by 윤여진 on 2022/07/27.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    static let identifier: String = "ViewController"
    
    var navigationTitleString: String { //= "대장님의 다마고치"
        get{
            return "대장님의 다마고치"
        }
        set{
            title = newValue
        }
    }
    var backgroundColor: UIColor {
        get {
            return .blue
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // ViewPresentableProtocol
    func configureView() {
        
        navigationTitleString = "고래밥님의 다마고치"
        title = navigationTitleString
        // view.backgroundColor = backgroundColor
    }
    
    func configureLabel() {
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        
        return cell
    }
   

}

