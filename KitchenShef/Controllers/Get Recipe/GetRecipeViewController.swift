//
//  GetRecipeViewController.swift
//  KitchenShef
//
//  Created by Shubham Kapoor on 20/12/18.
//  Copyright © 2018 Shubham Kapoor. All rights reserved.
//

import UIKit
import WebKit

class GetRecipeViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var recipeURL = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = URL(string: recipeURL) else { return }
        webView.load(URLRequest(url: url))
    }
    
    //    MARK:- IBActions
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
