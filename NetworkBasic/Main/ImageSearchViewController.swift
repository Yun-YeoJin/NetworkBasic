//
//  ImageSearchViewController.swift
//  NetworkBasic
//
//  Created by 윤여진 on 2022/08/03.
//

import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher
import SwiftUI

class ImageSearchViewController: UIViewController {
    
    
    var list: [String] = []
    
    //네트워크 요청 시 시작 페이지 넘버
    var startPage = 1
    var totalCount = 0
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        searchBar.delegate = self
        
        collectionView.register(UINib(nibName: "ImageSearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ImageSearchCollectionViewCell.reuseIdentifier)
        
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let width = UIScreen.main.bounds.width - (spacing * 4)
        
        layout.itemSize = CGSize(width: width / 3, height: (width / 3) * 1.2)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = spacing
        
        collectionView.collectionViewLayout = layout
        
    }
    
    
    //fetchImage, requestImage, callRequestImage, getImage... 등
    func requestImage(query: String) {
        
        ImageSearchAPIManager.shared.fetchImageData(query: query, startPage: startPage) { totalCount, list in
            self.totalCount = totalCount
            self.list.append(contentsOf: list)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
           
        }

    }
}

extension ImageSearchViewController: UISearchBarDelegate {
    
    //검색 버튼 클릭 시 실행. 검색 단어가 바뀔 수 있음
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let text = searchBar.text {
            list.removeAll()
            startPage = 1
            requestImage(query: text)
        }
    }
    // 취소 버튼 눌렀을 때 실행
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        list.removeAll()
        collectionView.reloadData()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
    }
    // 서치바에 커서가 깜박이기 시작할 때 실행
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
}


//MARK: 페이지네이션 방법3. Prefetching 사용하기
//용량이 큰 이미지를 다운받아 셀에 보여주려고 하는 경우에 효과적임.
//셀이 화면에 보이기 전에 미리 필요한 리소스를 다운받을 수 있고, 필요하지 않다면 데이터를 취소할 수도 있음.
//iOS 15 이상, 스크롤 성능 향상됨.
extension ImageSearchViewController: UICollectionViewDataSourcePrefetching {
    
    //셀이 화면에 보이기 전에 필요한 리소스를 미리 다운 받을 수 있다.
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            if list.count - 1 == indexPath.item && list.count < totalCount {
                startPage += 40
                requestImage(query: searchBar.text!)
            }
        }
        
        print("======\(indexPaths)======")
    }
    
    //취소
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        print("======취소:\(indexPaths)======")
    }
    
}

extension ImageSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageSearchCollectionViewCell", for: indexPath) as? ImageSearchCollectionViewCell else { return UICollectionViewCell() }
        
        let url = URL(string: list[indexPath.item])
        cell.snackImageView.kf.setImage(with: url)
        cell.snackImageView.backgroundColor = .clear
        return cell
    }
    
    //MARK: 페이지네이션 방법1. 컬렉션뷰가 특정 셀을 그리려는 시점에 호출되는 메서드
    //마지막 셀에 사용자가 위치해 있는지 명확하게 확인하기 어려움 (권장하는 방식이 아님)
    //    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    //        <#code#>
    //    }
    
    //MARK: 페이지네이션 방법2. UIScrollViewDelegateProtocol
    //TableView, CollectionView는 ScrollView를 상속받고 있어서 ScrollViewDelegateProtocol을 채택할 수 있음
    
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        print(scrollView.contentOffset)
    //    }
    
}

//extension ImageSearchViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        let width = collectionView.frame.size.width
//        
//        return CGSize (width: collectionView.bounds.width, height: width)
//    }
//}
