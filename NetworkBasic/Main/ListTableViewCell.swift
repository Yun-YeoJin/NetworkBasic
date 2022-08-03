//
//  ListTableViewCell.swift
//  NetworkBasic
//
//  Created by 윤여진 on 2022/07/27.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    static let identifier = "ListTableViewCell"
  
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var rankLabel: UILabel!
    
}
