//
//  FoodTableViewController.swift
//  Splurged
//
//  Created by Zhou, Alexander on 7/12/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit

class FoodTableViewController: UITableViewController {
    
    let foods = ["Fast Food", "Sandwiches", "Mexican", "Italian", "Desserts", "Breakfast", "Pizza", "Asian", "Vegan"]


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let foodType = foods[indexPath.row]
        cell.textLabel!.text = foodType
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dvc = segue.destination as! foodMapViewController
        let index = tableView.indexPathForSelectedRow?.row
        dvc.food = foods[index!]
    }
}
