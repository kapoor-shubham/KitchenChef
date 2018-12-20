//
//  DashboardViewController.swift
//  KitchenShef
//
//  Created by Shubham Kapoor on 19/12/18.
//  Copyright © 2018 Shubham Kapoor. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var dishTextField: UITextField!
    
    let handpickedDishes = ["Buttered popcorn", "Masala dosa", "Potato chips", "Seafood paella", "Som tam", "Chicken rice", "Poutine", "Tacos", "Tofu", "Marzipan", "French toast", "Chicken parm", "Hummus", "Chili crab", "Pho", "Fajitas", "Butter garlic crab", "Lasagna", "Croissant", "Bunny chow", "Kebab", "Pierogi", "Donuts"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //    MARK:- IBActions
    @IBAction func goButtonAction(_ sender: UIButton) {
        guard let dishName = dishTextField.text else {
            print("No Dish to Search")
            return
        }
        serachDish(dishName: dishName)
    }
    
    //    MARK:- Private Methods
    func serachDish(dishName: String) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "DishDescriptionViewController") as! DishDescriptionViewController
        vc.searchDish = dishName
        self.navigationController?.pushViewController(vc, animated:true)
    }
}

extension DashboardViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return handpickedDishes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardTableViewCell", for: indexPath) as! DashboardTableViewCell
        cell.textLabel?.text = handpickedDishes[indexPath.section]
        cell.textLabel?.textColor = UIColor.white
        cell.selectionStyle = .none
        return cell
    }
}

extension DashboardViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 10))
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DashboardTableViewCell
        serachDish(dishName: (cell.textLabel?.text)!)
    }
}

