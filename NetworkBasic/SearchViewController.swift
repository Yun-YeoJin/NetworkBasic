//
//  SearchViewController.swift
//  NetworkBasic
//
//  Created by 윤여진 on 2022/07/27.
//

import UIKit

/*
 Swift Protocol
 - Delegate
 - DataSource
 
 
 1. 왼팔 / 오른팔
 2. 테이블뷰 아웃렛 연결
 3. 1 + 2 = self (ex. searchTableView.delegate = self)
 */

extension UIViewController {
    func setbackground() {
        view.backgroundColor = .opaqueSeparator
    }
}
// 상속받을 Class에 프로토콜 명을 써준다. (상속받을 Class가 항상 앞에 와야한다)

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

 
    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 연결고리 작업
        searchTableView.delegate = self
        searchTableView.dataSource = self
    
        // 테이블뷰가 사용할 테이블뷰 셀(XIB)
        // XIB: xml interface builder <= Nib
        searchTableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: ListTableViewCell.reuseIdentifier)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseIdentifier, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        
        cell.titleLabel.font = .boldSystemFont(ofSize: 15)
        cell.titleLabel.text = "Hello"
        
        return cell
    }
 
}
