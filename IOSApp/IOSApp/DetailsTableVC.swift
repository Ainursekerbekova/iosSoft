//
//  DetailsTableVC.swift
//  IOSApp
//
//  Created by Айнур on 4/12/20.
//  Copyright © 2020 sdu. All rights reserved.
//

import UIKit

class DetailsTableVC: UITableViewController {

    var order:Order?
    var spisok:[item]?
    var name:String?
    var add:String?
    var phone:String?
    var shop:String?
    var shopAdd:String?
    var total:String?
    @IBOutlet weak var ClientName: UILabel!
    @IBOutlet weak var ClientAddress: UILabel!
    @IBOutlet weak var ClientPhone: UILabel!
    @IBOutlet weak var Shop: UILabel!
    @IBOutlet weak var ShopAddress: UILabel!
    @IBOutlet weak var TotalSum: UILabel!
    
    @IBAction func Back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spisok = self.order?.items
        self.ClientName.text = name!
        self.ClientPhone.text = phone!
        self.ClientAddress.text = add!
        self.Shop.text = shop!
        self.ShopAddress.text = shopAdd!
        self.TotalSum.text = total!
        print(ClientPhone.text!)
        print("----------------------")
        print(spisok)
        self.tableView.reloadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spisok!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemsTableViewCell
        let obj = spisok![indexPath.row]
        cell.Title.text = "\(obj.title)"
        cell.Price.text = "\(String(describing: obj.price))"
        cell.Amount.text = "\(String(describing: obj.cnt))"
        cell.Barcode.text = "\( String(describing: obj.barcode))"
        cell.Sum_on_Item.text = "\( String(describing: obj.price))"

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}