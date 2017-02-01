//
//  TableViewCell.swift
//  ThreadApp1
//
//  Created by Vishwajeet Dagar on 1/25/17.
//  Copyright © 2017 Vishwajeet. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
