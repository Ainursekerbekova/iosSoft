//
//  ViewController.swift
//  IOSApp
//
//  Created by Айнур on 2/8/20.
//  Copyright © 2020 sdu. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    var RS:RequestSender?
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    @IBOutlet weak var ErrorLabel: UILabel!
    
    @IBAction func Login(_ sender: UIButton) {
        
        if (Username.text != "" && Password.text != ""){
            let pass = Password?.text
            let login = Username?.text
            let LogData = LogInData.init(login: login!, password: pass!)
            self.RS!.login(LogData){ result in
                let code = self.RS?.Response_code
                DispatchQueue.main.async {
                    if (code == 200){
                        let token = self.RS?.token
                        print("token: \(String(describing: token))")
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "myVCID") as! OrdersTableViewController
                        vc.RS = self.RS
                        vc.token = token
                        self.present(vc, animated: true, completion: nil)
                        
                        
                        print("shown")
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
        RS = RequestSender.init()
        ErrorLabel.text = ""
        // Do any additional setup after loading the view.
    }
    
    func showError(_ text:String) {
        ErrorLabel.text = text
    }
    


}

