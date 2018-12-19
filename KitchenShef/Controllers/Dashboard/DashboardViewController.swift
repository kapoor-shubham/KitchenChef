//
//  DashboardViewController.swift
//  KitchenShef
//
//  Created by Shubham Kapoor on 19/12/18.
//  Copyright © 2018 Shubham Kapoor. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    let handpickedDishes = ["Buttered popcorn", "Masala dosa", "Potato chips", "Seafood paella", "Som tam", "Chicken rice", "Poutine", "Tacos", "Tofu", "Marzipan", "French toast", "Chicken parm", "Hummus", "Chili crab", "Pho", "Fajitas", "Butter garlic crab", "Lasagna", "Croissant", "Bunny chow", "Kebab", "Pierogi", "Donuts"]

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let vc = storyBoard.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
//        vc.backLabelText = headerLabel.text!
//        self.navigationController?.pushViewController(vc, animated:true)
//    }
}

