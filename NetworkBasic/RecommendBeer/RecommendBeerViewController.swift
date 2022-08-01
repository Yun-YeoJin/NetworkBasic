//
//  RecommendBeerViewController.swift
//  NetworkBasic
//
//  Created by 윤여진 on 2022/08/01.
//

import UIKit

import Alamofire
import SwiftyJSON

class RecommendBeerViewController: UIViewController {
    
    
    @IBOutlet weak var beerNameLabel: UILabel!
    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var beerDescriptionTextView: UITextView!
    
    
    @IBOutlet weak var randomButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestBeerAPI()
        
        
    }
    
    func requestBeerAPI() {
        
        //AF: 200-299 status Code
        let url = "https://api.punkapi.com/v2/beers/random"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                print("JSON: \(json)")
                
                let beerName = json[0]["name"].stringValue
                self.beerNameLabel.text = beerName
                
                let beerDescription = json[0]["description"].stringValue
                self.beerDescriptionTextView.text = beerDescription
                
                let image_url = URL(string: json[0]["image_url"].string ?? "https://images.punkapi.com/v2/131.png")
                let data = try? Data(contentsOf: image_url!)
                self.beerImageView.image = UIImage(data: data!)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func randomButtonClicked(_ sender: UIButton) {
        
        requestBeerAPI()
    }
    
    
}


