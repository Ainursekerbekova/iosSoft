//  Order.swift
//  IOSApp
//
//  Created by Айнур on 2/9/20.
//  Copyright © 2020 sdu. All rights reserved.


import Foundation
struct list:Codable{
    var orders:[Order]
    init(_ dictionary: [[String: Any]]?) {
        orders=[]
        for i in 0...(dictionary!.count-1){
            let one_order = dictionary![i]
            orders.append(Order.init(one_order))
        }
    }
}
struct Order:Codable {
    var id:String
    var client_name:String
    var client_address:String
    var store_id:String?
    var date:String
    var is_card:Bool?
    var is_bcc_card:Bool?
    var total: String
    var status:String
    var status_id:String
    var delivery_type:String?
    var delivery_price:String
    var client_phone:String
    var items:[item]
    var taken:Int?
    var runner: String
    var lat:String?
    var lng:String?
    var distance:String
    init(_ dictionary: [String: Any]? ) {
        id = dictionary!["id"] as! String
        client_name = dictionary!["client_name"] as! String
        client_address = dictionary!["client_address"] as! String
        store_id = dictionary!["store_id"] as? String
        date = dictionary!["date"] as! String
        is_card = dictionary!["is_card"] as? Bool
        is_bcc_card = dictionary!["is_bcc_card"] as? Bool
        total = dictionary!["total"] as! String
        status = dictionary!["status"] as! String
        status_id = dictionary!["status_id"] as! String
        delivery_type = dictionary!["delivery_type"] as? String
        delivery_price = dictionary!["delivery_price"] as! String
        client_phone = dictionary!["client_phone"] as! String
        taken = dictionary!["taken"] as? Int
        runner = dictionary!["runner"] as! String
        lat = (dictionary!["lat"] as! String)
        lng = (dictionary!["lng"] as! String)
        distance = dictionary!["distance"] as! String
        items=[]
        let items_dict = dictionary!["items"] as? [[String: Any]]
        for i in 0...(items_dict!.count-1){
            let one_item = items_dict![i]
            items.append(item.init(one_item))
        }
    }
}
struct item :Codable{
    var title: String
    var price: Int?
    var cnt:String?
    var grams:String?
    var barcode:String?
    init(_ dictionary: [String: Any]?) {
        title = dictionary!["title"] as! String
        price = dictionary!["price"] as? Int
        cnt = (dictionary!["cnt"] as! String)
        grams = (dictionary!["grams"] as! String)
        barcode = (dictionary!["barcode"] as! String)
    }
}

struct LogInData:Codable {
    var login: String
    var password: String
    
}
struct ChangeStatusData:Codable {
    var status_id: Int
    var id:Int
}
struct VerifyCodeData:Codable {
    var code: String
}
struct Shop:Codable {
    var id: Int
    var address: String
    var lat: Double
    var lng: Double
    var image: String
    var title: String
    init(_ dictionary: [String: Any]?) {
        id = dictionary!["id"] as! Int
        address = dictionary!["address"] as! String
        lat = dictionary!["lat"] as! Double
        lng = dictionary!["lng"] as! Double
        image = dictionary!["image"] as! String
        title = dictionary!["title"] as! String
    }
}

struct PersonStruct {
    var id: Int
    var rating: Int
    var money:Int
    var username:String
    var order: Order?
}
