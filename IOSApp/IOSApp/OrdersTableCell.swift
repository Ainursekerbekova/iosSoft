//  OrdersTableCell.swift
//  IOSApp
//
//  Created by Айнур on 2/9/20.
//  Copyright © 2020 sdu. All rights reserved.


import UIKit

class OrdersTableCell: UITableViewCell {
    
    var order:Order?
    @IBOutlet weak var ClientName: UILabel!
    @IBOutlet weak var ClientAdress: UILabel!
    @IBOutlet weak var ClientPhone: UILabel!
    @IBOutlet weak var Price: UILabel!
    @IBOutlet weak var Paying: UILabel!
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var Status: UILabel!
    @IBAction func TakeOrder(_ sender: UIButton) {
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
