//
//  DishDescriptionViewController.swift
//  KitchenShef
//
//  Created by Shubham Kapoor on 20/12/18.
//  Copyright © 2018 Shubham Kapoor. All rights reserved.
//

import UIKit
import MBProgressHUD

class DishDescriptionViewController: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var getRecipeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let appKey = "bcc8e4d2d7901b205794f730714a838b"
    let appID = "0f33bfee"
    var searchDish = String()
    
    var recipeURL = String()
    var recipeIngredients = [String]()
    var tableData = [String: [String: AnyObject]]()
    var tableSection = [String]()
    var selectedSection: String?
    var dictKeys = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Getting your dish..."
        headerLabel.text = searchDish
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 50.0
        getDishData()
    }
    
    //    MARK:- IBActions
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func getRecipeButtonAction(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "GetRecipeViewController") as! GetRecipeViewController
        vc.recipeURL = recipeURL
        self.navigationController?.pushViewController(vc, animated:true)
    }
    
    //    MARK:- Private Methods
    func getDishData() {
        let urlString = "https://api.edamam.com/search?q=\(searchDish)&app_id=\(appID)&app_key=\(appKey)&from=0&to=10"
        let convertedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let url : URL = URL(string: convertedUrlString!)!
        let request: URLRequest = URLRequest(url:url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if(error != nil){
                print(error?.localizedDescription ?? "")
            }
            else{
                do{
                    let jsonDict:NSDictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                    let quotes = jsonDict.value(forKey: "hits")
                    if let dishData = (((quotes as! NSArray)[0]) as! [String: AnyObject])["recipe"] {
                        self.breakDishData(data: dishData as! [String : AnyObject])
                    }
                }
                catch{
                    print(error.localizedDescription)
                }
            }
        };
        task.resume()
    }
    
    func breakDishData(data: [String: AnyObject]) {
//        print(data)
        if let dishName = data["label"] as? String {
            DispatchQueue.main.async {
                self.dishNameLabel.text = dishName
            }
        }
        
        if let recipe = data["url"] as? String {
            recipeURL = recipe
            DispatchQueue.main.async {
                self.getRecipeButton.isUserInteractionEnabled = true
            }
        }
        
        if let ingredients = data["ingredientLines"] as? [String] {
            tableSection.append("Ingredients")
            recipeIngredients = ingredients
        }
        
        if let totalDaily = data["totalDaily"] as? [String: AnyObject] {
            tableSection.append("Total Daily Need")
            tableData["Total Daily Need"] = totalDaily
        }
        
        if let nutrients = data["totalNutrients"] as? [String: AnyObject] {
            tableSection.append("Nutrients")
            tableData["Nutrients"] = nutrients
            
        }
        
        DispatchQueue.main.async {
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    @objc func sectionButtonPressed(sender: UIButton!) {
        if selectedSection == sender.titleLabel?.text {
            selectedSection = nil
        } else {
            selectedSection = sender.titleLabel?.text
            if selectedSection != "Ingredients" {
                dictKeys = Array(tableData["\(selectedSection!)"]!.keys)
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK:- Extension UITableView DataSource
extension DishDescriptionViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableSection[section] == selectedSection {
            if selectedSection == "Ingredients" {
                return recipeIngredients.count
            } else {
                return (tableData["\(selectedSection!)"])!.count
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DishDescriptionTableViewCell", for: indexPath) as! DishDescriptionTableViewCell
        
        if indexPath.section == tableSection.index(of: "Ingredients") {
            cell.ingredientsLabel.isHidden = false
            cell.quantityLabel.isHidden = true
            cell.nutrientLabel.isHidden = true
            cell.ingredientsLabel.text = recipeIngredients[indexPath.row]
        } else if indexPath.section == tableSection.index(of: "\(selectedSection!)") {
            cell.ingredientsLabel.isHidden = true
            cell.quantityLabel.isHidden = false
            cell.nutrientLabel.isHidden = false
            cell.nutrientLabel.text =  tableData[tableSection[indexPath.section]]![dictKeys[indexPath.row]]!["label"]! as? String
            let quantityValue = tableData[tableSection[indexPath.section]]![dictKeys[indexPath.row]]!["quantity"]! as? Double
            let quantity: String = String(format: "%.2f", quantityValue!)
            let unit: String = "\((tableData[tableSection[indexPath.section]]![dictKeys[indexPath.row]]!["unit"]!)!)"
            cell.quantityLabel.text = "\(quantity) \(unit)"
        }
        return cell
    }
}

// MARK:- Extension UITableView Delegate
extension DishDescriptionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.backgroundColor = UIColor.black
        let selectionButton = UIButton(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        selectionButton.backgroundColor = UIColor.clear
        selectionButton.titleLabel?.textColor = UIColor.white
        selectionButton.setTitle(tableSection[section], for: .normal)
        selectionButton.addTarget(self, action: #selector(self.sectionButtonPressed), for: .touchUpInside)
        headerView.addSubview(selectionButton)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 15))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
}

//  MARK:- Extension To remove dish name spaces from url
extension String {
    static private let SNAKECASE_PATTERN:String = "(\\w{0,1})_"
    static private let CAMELCASE_PATTERN:String = "[A-Z][a-z,\\d]*"
    func snake_caseToCamelCase() -> String{
        let buf:NSString = self.capitalized.replacingOccurrences( of: String.SNAKECASE_PATTERN,
                                                                  with: "$1",
                                                                  options: .regularExpression,
                                                                  range: nil) as NSString
        return buf.replacingCharacters(in: NSMakeRange(0,1), with: buf.substring(to: 1).lowercased()) as String
    }
    func camelCaseTosnake_case() throws -> String {
        guard let pattern: NSRegularExpression = try? NSRegularExpression(pattern: String.CAMELCASE_PATTERN,
                                                                          options: []) else {
                                                                            throw NSError(domain: "NSRegularExpression fatal error occured.", code:-1, userInfo: nil)
        }
        
        let input:NSString = (self as NSString).replacingCharacters(in: NSMakeRange(0,1), with: (self as NSString).substring(to: 1).capitalized) as NSString
        var array = [String]()
        let matches = pattern.matches(in: input as String, options:[], range: NSRange(location:0, length: input.length))
        for match in matches {
            for index in 0..<match.numberOfRanges {
                array.append(input.substring(with: match.range(at: index)).lowercased())
            }
        }
        return array.joined(separator: "_")
    }
}
