//
//  WebViewController.swift
//  NetworkBasic
//
//  Created by 윤여진 on 2022/07/28.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var webView: WKWebView!
    
    var destinationURL: String = "https://www.apple.com"
    //App Transport Security Settings -> http로 시작하면 차단.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        openWebPage(url: destinationURL)
        searchBar.delegate = self
    }
    
    func openWebPage(url: String) {
        guard let url = URL(string: url) else {
            print("불가능한 URL")
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    
    
}

extension WebViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        openWebPage(url: searchBar.text!)
    }
}
