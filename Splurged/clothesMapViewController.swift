//
//  clothesMapViewController.swift
//  Splurged
//
//  Created by Devesh Bhor on 7/14/19.
//  Copyright © 2019 iOS. All rights reserved.
//
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

class clothesMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var clothesMap: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    var clothes = String()
    
    let locationManager = CLLocationManager()
    var region = MKCoordinateRegion()
    var mapItems = [MKMapItem]()
    var selectedMapItem = MKMapItem()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        clothesMap.showsUserLocation = true
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        clothesMap.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first!
        let center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        region = MKCoordinateRegion(center: center, span: span)
        clothesMap.setRegion(region, animated: true)
    }
    
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = clothes
        request.region = region
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let response = response {
                for mapItem in response.mapItems {
                    print(mapItem.name!)
                    self.mapItems.append(mapItem)
                }
                
                for mapItem in response.mapItems {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = mapItem.placemark.coordinate
                    annotation.title = mapItem.name
                    self.clothesMap.addAnnotation(annotation)
                    self.mapItems.append(mapItem)
                }
            }
        }
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
        performSegue(withIdentifier: "ShowClothesDetailsSegue", sender: nil)
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        for mapItem in mapItems {
            if mapItem.placemark.coordinate.latitude == view.annotation?.coordinate.latitude &&
                mapItem.placemark.coordinate.longitude == view.annotation?.coordinate.longitude {
                selectedMapItem = mapItem
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ClothesDetailsViewController {
            destination.selectedMapItem = selectedMapItem
        }
    }
    
    
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
    
    
}

