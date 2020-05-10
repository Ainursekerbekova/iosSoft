//
//  ViewController.swift
//  IOSApp
//
//  Created by Айнур on 2/8/20.
//  Copyright © 2020 sdu. All rights reserved.
//

import UIKit
import CoreData


class LoginViewController: UIViewController {
    
    var RS:RequestSender = RequestSender.init()
    var currentUser:[NSManagedObject] = []
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    @IBOutlet weak var ErrorLabel: UILabel!
    
    @IBAction func Login(_ sender: UIButton) {
        
        if (Username.text != "" && Password.text != ""){
            let pass = Password?.text
            let login = Username?.text
            let LogData = LogInData.init(login: login!, password: pass!)
            self.RS.login(LogData){ result in
                let code = self.RS.Response_code
                DispatchQueue.main.async {
                    if (code == 200){
                        self.save(login!, self.RS.token)
                        self.goFurther()
                    }else if(code == 401){
                        self.showError("Username or password is wrong, try again")
                    }else {
                        self.showError("\(code ?? 000)")
                    }
                }
            }
        }
        else{
            showError("Please, fill all fields")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ErrorLabel.text = ""
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        //self.DelALLCore()
        let sess = self.loadSession()
        if( sess.count != 0) {
            self.RS.token = sess[0].token!
            self.goFurther()
        }
        //self.DelALLCore()
    }
    
    func showError(_ text:String) {
        ErrorLabel.text = text
    }
    func goFurther() {
        let tabbar = self.storyboard?.instantiateViewController(withIdentifier: "myVCID") as! UITabBarController
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrdersView") as! Orders
        let personVC = self.storyboard?.instantiateViewController(withIdentifier: "PersonView") as! PersonalData
       
        vc.RS = self.RS
        personVC.RS = self.RS
        tabbar.viewControllers = [vc, personVC]
        self.present(tabbar, animated: true, completion: nil)
    }
    func loadSession()->[Session] {
        var arr:[Session] = []
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Session >(entityName: "Session")
            do{
                try arr = context.fetch(fetchRequest)
                for one in arr {
                    if one.user == nil{
                        context.delete(one)
                    }
                }
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
            for item in items {
                managedContext.delete(item)
            }
            try managedContext.save()
        } catch {
        }
    }
    func save(_ username: String,_ token:String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Session", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(username, forKeyPath: "user")
        person.setValue(token, forKeyPath: "token")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save session. \(error), \(error.userInfo)")
        }
    }
}

