//
//  foodMapViewController.swift
//  Splurged
//
//  Created by Devesh Bhor on 7/14/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class foodMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var foodMap: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    var region = MKCoordinateRegion()
    var selectedMapItem = MKMapItem()
    
    var locations: [CLLocation] = []
    var mapItems = [MKMapItem]()
   var food = String()
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        foodMap.showsUserLocation = true
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        foodMap.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first!
        let center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
        region = MKCoordinateRegion(center: center, span: span)
        foodMap.setRegion(region, animated: true)
    }
    
    var loaded = 0
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        if(loaded > 1) {
            return
        }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = food
        request.region = region
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let response = response {
//                for mapItem in response.mapItems {
//                    self.mapItems.append(mapItem)
////                    print(self.mapItems.count)
//                }
                for mapItem in response.mapItems {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = mapItem.placemark.coordinate
                    annotation.title = mapItem.name
                    self.foodMap.addAnnotation(annotation)
                    self.mapItems.append(mapItem)
                    print(String(self.mapItems.count) + "test")
                }
            }
        }
          loaded += 1
        
        tableView.reloadData()
     
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin")
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pinView")
            pinView?.canShowCallout = true
            pinView?.rightCalloutAccessoryView = UIButton(type: .infoLight)
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "ShowFoodDetailsSegue", sender: nil)
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        for mapItem in mapItems {
            if mapItem.placemark.coordinate.latitude == view.annotation?.coordinate.latitude &&
                mapItem.placemark.coordinate.longitude == view.annotation?.coordinate.longitude {
                selectedMapItem = mapItem
            }
        }
    }
    
    //    func insertNewObject(_ sender: Any) {
    //        for mapItem in mapItems {
    //            print("mapItems")
    //            if let location = locations.first {
    //                let mapItemLocation = CLLocation(latitude: mapItem.placemark.coordinate.latitude, longitude: mapItem.placemark.coordinate.longitude)
    //                let distance = mapItemLocation.distance(from: location)
    //                print(distance)
    //                var counter = 0
    //                if distance < 0.04 {
    //                    counter += 1
    //                }
    //                if counter == 0 {
    //                    let alert = UIAlertController(title: "There is no in your area.", message: nil, preferredStyle: .alert)
    //                    print("Nothing")
    //                    let insertAction = UIAlertAction(title: "OK", style: .default) { (action) in
    //                        self.performSegue(withIdentifier: "backToFoodTableSegue", sender: (Any).self)
    //                    }
    //                    alert.addAction(insertAction)
    //                    present(alert, animated: true, completion: nil)
    //                }
    //            }
    //        }
    //    }
    
    //
    //    //var mapItems = [MKMapItem]()
    //    override init(frame: CGRect, style: UITableView.Style) {
    //        print("huh")
    //    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        print(mapItems.count)
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            print(self.mapItems.count)
        }
        return mapItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(mapItems.count)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell" , for: indexPath)
        let mapItem = mapItems[indexPath.row]
//        print(mapItem)
        cell.textLabel!.text = mapItem.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        print(mapItems.count)
        return false
    }
    
    //        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //            let dvc = segue.destination as! foodMapViewController
    //            let index = tableView.indexPathForSelectedRow?.row
    //            dvc.food = foods[index!]
    //        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? FoodDetailsViewController {
            destination.selectedMapItem = selectedMapItem
        }
    }
}
