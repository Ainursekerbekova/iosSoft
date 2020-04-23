//
//  RequestSender.swift
//  IOSApp
//
//  Created by Айнур on 2/9/20.
//  Copyright © 2020 sdu. All rights reserved.
//

import Foundation

class RequestSender {
    var token:String = ""
    var Response_code:Int?
    var data:list?

    func login(_ Logdata:LogInData, completion: ((Bool) -> (Void))?) {
        guard let requestUrl = URL(string:"https://bb77fa9c.ngrok.io/runners/login") else { fatalError()}
        var request = URLRequest(url: requestUrl)
        var body:Data?
        do { body = try JSONEncoder().encode(Logdata)}
        catch { print("Error when encoding json : \(error.localizedDescription).")}
        request.httpBody = body!
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error took place \(error)")
                return
            }
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
                self.Response_code = response.statusCode
            }
            //handling data to string format
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response login data string:\n \(dataString)")
            }
            guard let data = data else { return }
            
            do {
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(convertedJsonIntoDict)
                    if (convertedJsonIntoDict["token"] != nil){
                        self.token = convertedJsonIntoDict["token"] as! String
                    }
                    completion?(true)
                }
            } catch let error as NSError {print(error.localizedDescription)}
        }
        task.resume()
    }
    
    func Allorders(completion: ((Bool) -> (Void))?) {
        guard let requestUrl = URL(string:"https://bb77fa9c.ngrok.io/runners/orders?page=1") else { fatalError()}
        var request = URLRequest(url: requestUrl)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(self.token, forHTTPHeaderField: "x-auth-token")
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // if error in getting response
            if let error = error {
                print("Error took place \(error)")
                return
            }
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            //handling data to string format
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
            }
            guard let data = data else { return }
            
    
            //handling data from json to stucts format //var 3
            /*do {
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(convertedJsonIntoDict)
                    let ordersInNSArray = convertedJsonIntoDict["orders"]
                   
                    let my_list = list.init(convertedJsonIntoDict["orders"] as! [String : Any] )
                    print(my_list)
                }
            } catch let error as NSError {print(error.localizedDescription)}
            */
            do {
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    //print( convertedJsonIntoDict["orders"] as! [[String : Any]])
                    let orders = convertedJsonIntoDict["orders"] as! [[String : Any]]
                    let my_list = list.init(orders )
                    self.data = my_list
                    completion?(true)
                }
            } catch let error as NSError {print(error.localizedDescription)}
        }
        task.resume()
    }
}
