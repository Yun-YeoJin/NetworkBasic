

import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher

class BeerListViewController: UIViewController {
    
    var list: [BeerList] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let width = UIScreen.main.bounds.width

        layout.itemSize = CGSize(width: width , height: (width / 2) )
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = spacing

        collectionView.collectionViewLayout = layout
        
        navigationItem.title = "맛있는 맥주 리스트"
    }
    
}

extension BeerListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BeerListCollectionViewCell.reuseIdentifier, for: indexPath) as! BeerListCollectionViewCell
        
        let url = "https://api.punkapi.com/v2/beers/random"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                print("JSON: \(json)")
                
                let beerName = json[0]["name"].stringValue
                cell.beerNameLabel.text = beerName
                cell.beerNameLabel.textAlignment = .center
                
                let beerDescription = json[0]["description"].stringValue
                cell.beerDescriptionLabel.text = beerDescription
                
                let image_url = URL(string: json[0]["image_url"].string ?? "")
                cell.beerImageView.kf.setImage(with: image_url)
                
            case .failure(let error):
                print(error)
            }
        }
        
        return cell
        
    }
    
}

//extension BeerListViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.bounds.width, height: 80)
//    }
//
//
//}
