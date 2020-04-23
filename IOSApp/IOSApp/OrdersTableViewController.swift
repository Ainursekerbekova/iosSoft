//
//  OrdersTableViewController.swift
//  IOSApp
//
//  Created by Айнур on 2/9/20.
//  Copyright © 2020 sdu. All rights reserved.
//

import UIKit

class OrdersTableViewController: UITableViewController {

    var RS:RequestSender?
    var token:String?
    var list:list?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.RS!.Allorders(){ result in
            let code = self.RS?.Response_code
            DispatchQueue.main.async {
                if (code == 200){
                    self.list = self.RS!.data!
                    var i=0
                    for order in self.list!.orders{
                        if order.status == "Доставлено"{
                            self.list?.orders.remove(at: i)
                            i=i-1
                        }
                        i=i+1
                    }
                    self.reload()
                }
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    func reload() {
        self.tableView.reloadData()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var spisok:[Order] = []
        if (list != nil){
            spisok = list!.orders
        }
        return spisok.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrdersTableCell

        let obj = list?.orders[indexPath.row]
        cell.ClientAdress.text = obj!.client_address
        cell.ClientName.text = obj!.client_name
        cell.ClientPhone.text = obj!.client_phone
        cell.Date.text = obj!.date
        cell.Status.text = obj!.status
        cell.order = obj

        return cell
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
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
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "OrderDetail"{
            let dest = segue.destination as! DetailsTableVC
            let cell = self.tableView.cellForRow(at: self.tableView.indexPathForSelectedRow!) as! OrdersTableCell
            print(String(describing: cell.order?.client_address))
            dest.add = "\(cell.order!.client_address)"
            dest.name = "\( cell.order!.client_name)"
            dest.phone = "\(cell.order!.client_phone)"
            dest.shop = "\( String(describing: cell.order!.store_id))"
            dest.shopAdd = "\( String(describing: cell.order!.store_id))"
            dest.total = "\( String(describing: cell.order!.total))"
            dest.order = cell.order
            
        }
    }
}
