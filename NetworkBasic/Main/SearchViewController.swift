//
//  SearchViewController.swift
//  NetworkBasic
//
//  Created by 윤여진 on 2022/07/27.
//

import UIKit

import Alamofire
import SwiftyJSON

/*
 Swift Protocol
 - Delegate
 - DataSource
 
 
 1. 왼팔 / 오른팔
 2. 테이블뷰 아웃렛 연결
 3. 1 + 2 = self (ex. searchTableView.delegate = self)
 */

/*
 각 Json value -> list append
 */

extension UIViewController {
    func setbackground() {
        view.backgroundColor = .opaqueSeparator
    }
}
// 상속받을 Class에 프로토콜 명을 써준다. (상속받을 Class가 항상 앞에 와야한다)

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    //BoxOffice 배열
    var list: [BoxOfficeModel] = []
    
    //타입 어노테이션 vs 타입 추론 => 누가 더 빠를까?
    var nickname: String = ""
    var username = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 연결고리 작업
        searchTableView.delegate = self
        searchTableView.dataSource = self
        movieSearchBar.delegate = self
        // 테이블뷰가 사용할 테이블뷰 셀(XIB)
        // XIB: xml interface builder <= Nib
        searchTableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: ListTableViewCell.reuseIdentifier)
        
        //MARK: 항상 어제의 날짜 나오게 하기
        let format = DateFormatter()
        format.dateFormat = "yyyyMMdd"
        //let dateResult = Date(timeIntervalSinceNow: -86400)
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date() ) //오늘 날짜로부터 day가 -1(하루전)
        let dateResult = format.string(from: yesterday!)
        
        //네트워크 통신: 서버 점검 등에 대한 예외 처리
        //네트워크가 느린 환경 테스트
        //실기기 테스트시 컨디션 조절 가능!
        //시뮬레이터에서도 가능! (추가설치 필요)
        
        requestBoxOffice(text: dateResult)
    }
    
    func requestBoxOffice(text: String) {
        
        list.removeAll()
        
        //AF: 200-299 status Code
        //인증키 제한
        let url = "\(EndPoint.boxOfficeURL)key=\(APIKey.BOXOFFICE)&targetDt=\(text)"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
            
                for movie in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
                    let movieNm = movie["movieNm"].stringValue
                    let openDt = movie["openDt"].stringValue
                    let rank = movie["rank"].stringValue
                    
                    let data = BoxOfficeModel(movieTitle: movieNm, releaseDate: openDt, movieRank: rank)
                    
                    self.list.append(data)
                }
                
                self.searchTableView.reloadData()
                
                print(self.list)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseIdentifier, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .clear
        cell.titleLabel.font = .boldSystemFont(ofSize: 15)
        cell.titleLabel.text = "\(list[indexPath.row].movieTitle)"
        cell.releaseDateLabel.text = "개봉일: \(list[indexPath.row].releaseDate)"
        cell.releaseDateLabel.font = .systemFont(ofSize: 13)
        cell.rankLabel.text = "\(list[indexPath.row].movieRank)"
        cell.rankLabel.font = .boldSystemFont(ofSize: 44)
        cell.rankLabel.textColor = .red
        
        return cell
    }
    
    
}
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        requestBoxOffice(text: searchBar.text ?? "\(Date())") //옵셔널 바인딩, 8글자인가, 숫자, 날짜로 변경 시 유효한 형태의 값인 지 확인이 필요하다.
    }
    
}
