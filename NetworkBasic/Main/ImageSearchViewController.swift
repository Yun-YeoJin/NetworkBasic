//
//  ImageSearchViewController.swift
//  NetworkBasic
//
//  Created by 윤여진 on 2022/08/03.
//

import UIKit

import Alamofire
import SwiftyJSON

class ImageSearchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestImage()
        
    }
    //fetchImage, requestImage, callRequestImage, getImage... 등
    
    func requestImage() {
        //MARK: GET 방식
        let text = "과자".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = EndPoint.imageSearchURL + "query=\(text)&display=20&start=21" //query가 한글이면 invalidURL오류가 뜬다. 한글을 UTF-8 인코딩을 거쳐서 되어야한다.
        let header: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]
        
        AF.request(url, method: .get, headers: header).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
