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

class foodMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var foodMap: MKMapView!
    
    let locationManager = CLLocationManager()
    var region = MKCoordinateRegion()
    var mapItems = [MKMapItem]()
    var selectedMapItem = MKMapItem()
    var food = String()
    var locations: [CLLocation] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        foodMap.showsUserLocation = true
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        foodMap.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first!
        let center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
        region = MKCoordinateRegion(center: center, span: span)
        foodMap.setRegion(region, animated: true)
    }
    
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = food
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
                    self.foodMap.addAnnotation(annotation)
                    self.mapItems.append(mapItem)
                }
                
            }
        }
        insertNewObject((Any).self)
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
    
    func insertNewObject(_ sender: Any) {
        for mapItem in mapItems {
            print("mapItems")
            if let location = locations.first {
                let mapItemLocation = CLLocation(latitude: mapItem.placemark.coordinate.latitude, longitude: mapItem.placemark.coordinate.longitude)
                let distance = mapItemLocation.distance(from: location)
                print(distance)
                var counter = 0
                if distance < 0.04 {
                    counter += 1
                }
                if counter == 0 {
                    let alert = UIAlertController(title: "There is no in your area.", message: nil, preferredStyle: .alert)
                    print("Nothing")
                    let insertAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        self.performSegue(withIdentifier: "backToFoodTableSegue", sender: (Any).self)
                    }
                    alert.addAction(insertAction)
                    present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? FoodDetailsViewController {
            destination.selectedMapItem = selectedMapItem
        }
    }
}
