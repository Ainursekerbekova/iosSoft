//
//  OrderDetailsVC.swift
//  IOSApp
//
//  Created by Айнур on 4/28/20.
//  Copyright © 2020 sdu. All rights reserved.
//

import UIKit
import CoreData

class OrderDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return spisok!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemsTableViewCell
        var obj = spisok![indexPath.row]
        cell.Title.text = "\(obj.title)"
        if ((obj.price) == nil ){
            obj.price = 2000
        }
        cell.Price.text = "х   \(String(describing: obj.price!)) тг"
        var item_sum = 0
        let price = Int(obj.price!)
        let count = Int(obj.cnt!)
        let grams = Int(obj.grams!)
        if (obj.cnt != "0"){
            cell.Amount.text = "\(obj.cnt!)  шт"
            item_sum = count! * price
        }else{
            cell.Amount.text = "\(obj.grams!)  гр"
            item_sum = grams! * price * 1 / 1000
        }
        cell.Barcode.text = "\( String(describing: obj.barcode!))"
        
        cell.Sum_on_Item.text = "\(item_sum) тг"
        
        return cell
    }
    
    @IBOutlet weak var ItemsTable: UITableView!
    @IBOutlet weak var ShopName: UILabel!
    @IBOutlet weak var ShopAddres: UILabel!
    @IBOutlet weak var TotalSum: UILabel!
    @IBOutlet weak var ClientName: UILabel!
    @IBOutlet weak var ClientAddress: UILabel!
    @IBOutlet weak var ClientPhone: UILabel!
    
    var order:Order?
    var spisok:[item]?
    var name:String?
    var add:String?
    var phone:String?
    var shop:String?
    var shopTitle:String?
    var shopAdd:String?
    var total:String?
    var CurrentUser:Session?
    var RS:RequestSender?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ItemsTable.dataSource = self
        ItemsTable.delegate = self
        self.CurrentUser = self.loadSession()[0]
        if (self.order?.status == "Принято" || self.order?.status == "Доставлено"){
            self.TakeButton.isHidden = true
            if (self.order?.runner != CurrentUser?.user || self.order?.status == "Доставлено"){
                self.DoneButton.isHidden = true
                self.CancelButton.isHidden = true
            }
        }else {
            self.DoneButton.isHidden = true
            self.CancelButton.isHidden = true
        }
        self.spisok = self.order?.items
        self.ClientName.text = name!
        self.ClientPhone.text = phone!
        self.ClientAddress.text = add!
        self.findShop()
        self.TotalSum.text = total!
        self.ItemsTable.reloadData()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }

    func findShop()  {
        let id = Int(self.shop!)
        self.RS?.FindShop( ){ result in
            print("shops:----------------------------------------------------------------")
            print(self.RS!.All_Shops!)
            for store in self.RS!.All_Shops!{
                print(store.id)
                print(id)
                if (store.id == id){
                    self.shopTitle = store.title
                    self.shopAdd = store.address
                    self.ShopName.text = self.shopTitle
                    self.ShopAddres.text = self.shopAdd
                }
            }
            
        }
    }
    
    @IBAction func Back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func CancelOrder(_ sender: UIButton) {
        let id = Int( order!.id)
        let sendData = ChangeStatusData.init(status_id: 4, id: id!)
        self.RS?.ChangeOrderStatus(data: sendData, completion: { Result in
            print(Result)
        })
    }
    
    @IBAction func DoneOrder(_ sender: UIButton) {
        let id = Int( order!.id)
        let sendData = ChangeStatusData.init(status_id: 3, id: id!)
        self.RS?.ChangeOrderStatus(data: sendData, completion: { Result in
            print(Result)
        })
        let AC = UIAlertController(title: "Введите код верификации", message: "На номер телефона клиента отправлен код верификации", preferredStyle: .alert)
        let sendcode = UIAlertAction(title: "Отправить", style: .default) { (UIAlertAction) in
            self.dismiss(animated: true, completion:  {
                 let textField = AC.textFields![0]
                 let code = textField.text
                 let verifyData = VerifyCodeData.init(code: code!)
                 self.RS?.VerifyCode(data: verifyData, completion: { Result in
                 print(Result)
                    let VC = self.presentedViewController as? Orders
                    VC?.updateList()
                
                 })
            })
        }
        AC.addTextField { (textField) in
            textField.placeholder = "Enter code"
        }
        AC.addAction(sendcode)
        self.present(AC, animated: true, completion: nil)
    }
    @IBAction func TakeOrder(_ sender: UIButton) {
        let id = Int( order!.id)
        let sendData = ChangeStatusData.init(status_id: 2, id: id!)
        self.RS?.ChangeOrderStatus(data: sendData, completion: { Result in
            print(Result)
        })
    }
    @IBOutlet weak var CancelButton: UIButton!
    @IBOutlet weak var DoneButton: UIButton!
    @IBOutlet weak var TakeButton: UIButton!
    
    
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

}
