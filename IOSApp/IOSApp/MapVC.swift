//
//  MapVC.swift
//  IOSApp
//
//  Created by Айнур on 5/3/20.
//  Copyright © 2020 sdu. All rights reserved.
//

import UIKit
import MapKit
import CoreData

struct Place {
    var long:String
    var lat:String
    var name:String
}


class MapVC: UIViewController, MKMapViewDelegate {

    
    @IBOutlet weak var Map: MKMapView!
    let myPlace:Place = Place.init(long: "51.136960", lat: "71.469185", name: "home")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Map.delegate = self

        // Do any additional setup after loading the view.
    }
    
    
    func set_all_Annotations(){
        let annotation = MKPointAnnotation()
        annotation.title = myPlace.name
        annotation.coordinate =  CLLocationCoordinate2DMake(myPlace.lat as! CLLocationDegrees, myPlace.long as! CLLocationDegrees)
        Map.addAnnotation(annotation)
        let first = Map.annotations[0]
        Map.setCenter(first.coordinate, animated: true)
        let span : MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region : MKCoordinateRegion = MKCoordinateRegion(center: Map.centerCoordinate, span: span)
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
