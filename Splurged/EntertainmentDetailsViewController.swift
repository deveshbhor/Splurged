//
//  FoodDetailsViewController.swift
//  Splurged
//
//  Created by Dayo-Kayode, Adedunni on 7/15/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit
import MapKit
import SafariServices

class EntertainmentDetailsViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
   @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    

    
    var selectedMapItem = MKMapItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedMapItem.name!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nameLabel.text = selectedMapItem.placemark.name
        var address = selectedMapItem.placemark.subThoroughfare! + " "
        address += selectedMapItem.placemark.thoroughfare! + "\n"
        address += selectedMapItem.placemark.locality! + ", "
        address += selectedMapItem.placemark.administrativeArea! + " "
        address += selectedMapItem.placemark.postalCode!
        addressLabel.text = address
        phoneLabel.text = selectedMapItem.phoneNumber
    }
    
    @IBAction func onDirectionsButtonTapped(_ sender: Any) {
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        MKMapItem.openMaps(with: [selectedMapItem], launchOptions: launchOptions)
    }
    
    @IBAction func onWebsiteButtonTapped(_ sender: Any) {
        if let url = selectedMapItem.url {
            present(SFSafariViewController(url: url), animated: true)
        }
    }
}
