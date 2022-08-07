//
//  ImageSearchAPIManager.swift
//  NetworkBasic
//
//  Created by 윤여진 on 2022/08/05.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

// 클래스 싱글턴 패턴 vs 구조체 싱글턴 패턴 비교.
class ImageSearchAPIManager {
    
    static let shared = ImageSearchAPIManager()
    
    private init() { }
    
    typealias completionHandler = (Int, [String]) -> Void
    
    func fetchImageData(query: String, startPage: Int, completionHandler: @escaping completionHandler) {
  
        let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        
        let url = EndPoint.imageSearchURL + "query=\(text)&display=40&start=\(startPage)" //query가 한글이면 invalidURL오류가 뜬다. 한글을 UTF-8 인코딩을 거쳐서 되어야한다.
        let header: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]
        
        AF.request(url, method: .get, headers: header).validate().responseData(queue: .global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let totalCount = json["total"].intValue
                
                // for item in json["items"].arrayValue {
                // self.list.append(item["link"].stringValue)
                // }
                
                let list = json["items"].arrayValue.map { $0["link"].stringValue } //$0(첫번째 배열)안에 link를 담는다.
                
                completionHandler(totalCount, list)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

