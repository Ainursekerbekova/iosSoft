//
//  PersonalData.swift
//  IOSApp
//
//  Created by Айнур on 5/3/20.
//  Copyright © 2020 sdu. All rights reserved.
//

import UIKit
import CoreData

class PersonalData: UIViewController {

    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Rating: UILabel!
    @IBOutlet weak var Money: UILabel!
    @IBOutlet weak var ClientName: UILabel!
    @IBOutlet weak var ClientAddress: UILabel!
    @IBOutlet weak var OrderDetailButton: UIButton!
    @IBOutlet weak var DeliveryPrice: UILabel!
    @IBOutlet weak var OrderDate: UILabel!
    @IBOutlet weak var Status: UILabel!
    @IBOutlet weak var AddLabel: UILabel!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var PriceLabel: UILabel!
    @IBOutlet weak var Activity: UIActivityIndicatorView!
    
    
    @IBAction func Update(_ sender: UIButton) {
        self.Activity.isHidden = false
        self.Activity.startAnimating()
        self.RS!.PersonData(){ result in
            let code = self.RS!.Response_code
            DispatchQueue.main.async {
                if (code == 200){
                    self.person = self.RS!.persData
                    self.setdata()
                    self.Activity.isHidden = true
                    self.Activity.stopAnimating()
                }
            }
        }
    }
    
    var RS:RequestSender?
    var token:String?
    var CurrentUser:Session?
    var person:PersonStruct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Activity.isHidden = false
        self.Activity.startAnimating()
        self.CurrentUser = self.loadSession()[0]
        self.RS!.PersonData(){ result in
            let code = self.RS!.Response_code
            DispatchQueue.main.async {
                if (code == 200){
                    self.person = self.RS!.persData
                    self.setdata()
                    self.Activity.isHidden = true
                    self.Activity.stopAnimating()
                }
            }
        }
    }
    
    func setdata()  {
        if (self.person?.order != nil){
            self.ClientAddress.text = self.person?.order?.client_address
            self.ClientName.text = self.person?.order?.client_name
            self.DeliveryPrice.text = self.person?.order?.delivery_price
            self.OrderDate.text = self.person?.order?.date
            self.Status.text = self.person?.order?.status
            self.OrderDetailButton.isHidden = false
            self.NameLabel.isHidden = false
            self.AddLabel.isHidden = false
            self.PriceLabel.isHidden = false
        }else{
            self.ClientAddress.isHidden = true
            self.ClientName.isHidden = true
            self.DeliveryPrice.isHidden = true
            self.OrderDate.isHidden = true
            self.Status.isHidden = true
            self.OrderDetailButton.isHidden = true
            self.AddLabel.isHidden = true
            self.PriceLabel.isHidden = true
            self.NameLabel.isHidden = true
        }
        self.Name.text = self.person?.username
        self.Money.text = String(self.person!.money)
        self.Rating.text = String(self.person!.rating)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToDetail"{
            let dest = segue.destination as! OrderDetailsVC
            dest.add = "\(person!.order!.client_address)"
            dest.name = "\( person!.order!.client_name)"
            dest.phone = "\(person!.order!.client_phone)"
            person!.order!.store_id = "3"
            dest.shop = "\( String(describing: person!.order!.store_id!))"
            dest.shopAdd = "\( String(describing: person!.order!.store_id!))"
            dest.total = "\( String(describing: person!.order!.total))"
            dest.order = person!.order
            dest.RS = self.RS!
        }
        if segue.identifier == "logout"{
            self.DelALLCore()
        }
    }
    

    
    
    
    
    
    
    
    
    
    
    
    
    func loadSession()->[Session] {
        var arr:[Session] = []
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Session>(entityName: "Session")
            do{
                try arr = context.fetch(fetchRequest)
            }catch{
                print("Error in loading")
            }
        }
        return arr
    }
    func DelALLCore()  {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Session >(entityName: "Session")
        fetchRequest.includesPropertyValues = false
        do {
            let items = try managedContext.fetch(fetchRequest)
            for item in items {managedContext.delete(item)}
            try managedContext.save()
        } catch {}
    }
}
