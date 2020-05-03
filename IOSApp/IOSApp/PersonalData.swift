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
    
    
    var RS:RequestSender?
    var token:String?
    var CurrentUser:Session?
    var person:PersonStruct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CurrentUser = self.loadSession()[0]
        self.RS!.PersonData(){ result in
            let code = self.RS!.Response_code
            DispatchQueue.main.async {
                if (code == 200){
                    self.person = self.RS!.persData
                    self.setdata()
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func setdata()  {
        self.Name.text = self.person?.username
        self.Money.text = String(self.person!.money)
        self.Rating.text = String(self.person!.rating)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
