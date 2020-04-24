//
//  Orders.swift
//  IOSApp
//
//  Created by Айнур on 4/24/20.
//  Copyright © 2020 sdu. All rights reserved.
//

import UIKit

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
        if(obj!.status == "Доставлено" ){
            cell.subviews[0].subviews[1].isHidden = true
        }
        if( obj!.status == "В ожидании"){
            cell.subviews[0].subviews[1].isHidden = false
        }
        if( obj!.status == "Принято"){
            cell.subviews[0].subviews[1].isHidden = true
        }
        cell.order = obj
        cell.RS = self.RS
        
        return cell
    }
    
    
    

    var RS:RequestSender?
    var token:String?
    var list:list?
    var page_num:Int = 1
    
    @IBOutlet weak var Table: UITableView!
    
    func reload() {
        self.Table.reloadData()
    }
    
    @IBAction func MoreOrders(_ sender: UIButton) {
        self.page_num = page_num+1
        self.RS!.Allorders(page_num){ result in
            let code = self.RS?.Response_code
            DispatchQueue.main.async {
                if (code == 200){
                    var more_list = self.RS!.data
                    if (more_list == nil){
                        //tut dolgna ischeznut knopka  co slovami net bolshe zakazov
                    }else{
                        var i=0
                        var to_end:[Order]=[]
                        var to_middle:[Order]=[]
                        for order in more_list!.orders{
                            if (order.status == "Принято"  && order.runner != self.RS!.Current_User){
                                to_middle.append(order)
                                more_list!.orders.remove(at: i)
                                i=i-1
                            }
                            if (order.status == "Доставлено"  ){
                                to_end.append(order)
                                more_list!.orders.remove(at: i)
                                i=i-1
                            }
                            i=i+1
                        }
                        more_list!.orders.append(contentsOf: to_middle)
                        more_list!.orders.append(contentsOf: to_end)
                        self.list?.orders.append(contentsOf: more_list!.orders)
                    }
                    
                    self.reload()
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Table.dataSource = self
        Table.delegate = self
        self.RS!.Allorders(1){ result in
            let code = self.RS?.Response_code
            DispatchQueue.main.async {
                if (code == 200){
                    self.list = self.RS!.data!
                    var i=0
                    var to_end:[Order]=[]
                    var to_middle:[Order]=[]
                    for order in self.list!.orders{
                        if (order.status == "Принято"  && order.runner != self.RS!.Current_User){
                            to_middle.append(order)
                            self.list?.orders.remove(at: i)
                            i=i-1
                        }
                        if (order.status == "Доставлено"  ){
                            to_end.append(order)
                            self.list?.orders.remove(at: i)
                            i=i-1
                        }
                        i=i+1
                    }
                    self.list?.orders.append(contentsOf: to_middle)
                    self.list?.orders.append(contentsOf: to_end)
                    self.reload()
                }
         }
        }

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "OrderDetail"{
            let dest = segue.destination as! DetailsTableVC
            let cell = self.Table.cellForRow(at: self.Table.indexPathForSelectedRow!) as! OrdersTableCell
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
