//
//  ItemsTableViewCell.swift
//  IOSApp
//
//  Created by Айнур on 4/12/20.
//  Copyright © 2020 sdu. All rights reserved.
//

import UIKit

class ItemsTableViewCell: UITableViewCell {
    @IBOutlet weak var Price: UILabel!
    @IBOutlet weak var Sum_on_Item: UILabel!
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Amount: UILabel!
    @IBOutlet weak var Barcode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
