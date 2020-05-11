//
//  Orders.swift
//  IOSApp
//
//  Created by Айнур on 4/24/20.
//  Copyright © 2020 sdu. All rights reserved.
//

import UIKit
import CoreData


class Orders: UIViewController, UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var spisok:[Order] = []
        if (list != nil){
            spisok = list!.orders
        }
        return spisok.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrdersTableCell
        let obj = list?.orders[indexPath.row]
        cell.ClientAdress.text = obj!.client_address
        cell.ClientName.text = obj!.client_name
        cell.Date.text = obj!.date
        cell.Status.text = obj!.status
        cell.Price.text = obj!.delivery_price + "тг"
        cell.ActivityIndicator.isHidden = true
        if(obj!.status == "Доставлено" ){
            cell.subviews[0].subviews[1].isHidden = true
        }
        if(obj!.status == "В ожидании"){
            cell.subviews[0].subviews[1].isHidden = false
        }
        if(obj!.status == "Принято"){
            cell.subviews[0].subviews[1].isHidden = true
        }
        cell.order = obj
        cell.RS = self.RS
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let obj = list?.orders[indexPath.row]
        if(obj!.status == "Доставлено" || obj!.status == "Принято"){
            return 160
        }
        return 195
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    

    var RS:RequestSender?
    var token:String?
    var list:list?
    var page_num:Int = 1
    var CurrentUser:Session?
    let myRefreshControl: UIRefreshControl = {
        let RC = UIRefreshControl()
        RC.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return RC
    }()
    
    @IBOutlet weak var Table: UITableView!
    @IBOutlet weak var MoreButton: UIButton!
    @IBAction func MoreOrders(_ sender: UIButton) {
        self.page_num = page_num+1
        self.RS!.Allorders(page_num){ result in
            let code = self.RS?.Response_code
            DispatchQueue.main.async {
                if (code == 200){
                    let more_list = self.RS!.data
                    if (more_list == nil){
                        //tut dolgna ischeznut knopka  co slovami net bolshe zakazov
                        self.MoreButton.isHidden = true
                    }else{
                        self.list?.orders.append(contentsOf: more_list!.orders)
                    }
                    self.sortOrders()
                    self.reload()
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Table.dataSource = self
        Table.delegate = self
        self.CurrentUser = self.loadSession()[0]
        self.updateList()
        self.Table.refreshControl = myRefreshControl
    }
    
    @objc func refresh(sender:UIRefreshControl) {
        page_num = 1
        self.RS!.Allorders(1){ result in
            let code = self.RS!.Response_code
            DispatchQueue.main.async {
                if (code == 200){
                    self.list = self.RS!.data!
                    self.sortOrders()
                    self.reload()
                    sender.endRefreshing()
                }
            }
        }
        self.MoreButton.isHidden = false
    }
    
    func updateList(){
        page_num = 1
        self.RS!.Allorders(1){ result in
            let code = self.RS!.Response_code
            DispatchQueue.main.async {
                if (code == 200){
                    self.list = self.RS!.data!
                    self.sortOrders()
                    self.reload()
                }
            }
        }
        self.MoreButton.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OrderDetail"{
            let dest = segue.destination as! OrderDetailsVC
            let cell = self.Table.cellForRow(at: self.Table.indexPathForSelectedRow!) as! OrdersTableCell
            dest.add = "\(cell.order!.client_address)"
            dest.name = "\(cell.order!.client_name)"
            dest.phone = "\(cell.order!.client_phone)"
            dest.shop = "\(cell.order!.store_id!)"
            dest.shopAdd = "\(cell.order!.store_id!)"
            dest.total = cell.order!.total + " тг"
            dest.order = cell.order
            dest.RS = self.RS!
        }
    }

    func loadSession()->[Session] {
        var arr:[Session] = []
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Session >(entityName: "Session")
            do{
                try arr = context.fetch(fetchRequest)
            }catch{
                print("Error in loading")
            }
        }
        return arr
    }
    func sortOrders()  {
        var my:Order?
        var CanTake:[Order] = []
        var Taken:[Order] = []
        var Done:[Order] = []
        for ord in list!.orders{
            if(ord.status == "Доставлено" ){
                Done.append(ord)
            }
            if( ord.status == "В ожидании"){
                CanTake.append(ord)
            }
            if( ord.status == "Принято"){
                if (ord.runner == self.CurrentUser?.user){
                    my = ord
                }else{
                    Taken.append(ord)
                }
            }
        }
        var all:[Order] = []
        if (my != nil){ all.append(my!)}
        all.append(contentsOf: CanTake)
        all.append(contentsOf: Taken)
        all.append(contentsOf: Done)
        list?.orders = all
    }
    func reload() {
        self.Table.reloadData()
    }
    
}
