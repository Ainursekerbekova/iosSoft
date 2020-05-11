//  OrdersTableCell.swift
//  IOSApp
//
//  Created by Айнур on 2/9/20.
//  Copyright © 2020 sdu. All rights reserved.


import UIKit

class OrdersTableCell: UITableViewCell {
    
    var order:Order?
    var RS:RequestSender?
    @IBOutlet weak var ClientName: UILabel!
    @IBOutlet weak var ClientAdress: UILabel!
    @IBOutlet weak var Price: UILabel!
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var Status: UILabel!
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!    
    @IBAction func TakeOrder(_ sender: UIButton) {
        self.TakeOrderButton.isHidden = true
        self.ActivityIndicator.isHidden = false
        self.ActivityIndicator.startAnimating()
        let id = Int( order!.id)
        let sendData = ChangeStatusData.init(status_id: 2, id: id!)
        self.RS?.ChangeOrderStatus(data: sendData, completion: { Result in
            print(Result)
            self.ActivityIndicator.isHidden = true
            self.ActivityIndicator.stopAnimating()
            self.Status.text = "Принято"
            self.order?.status_id = "2"
            self.order?.status = "Принято"
        })
    }
    
    @IBOutlet weak var TakeOrderButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
