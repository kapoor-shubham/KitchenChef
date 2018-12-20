//
//  DishDescriptionTableViewCell.swift
//  KitchenShef
//
//  Created by Shubham Kapoor on 20/12/18.
//  Copyright © 2018 Shubham Kapoor. All rights reserved.
//

import UIKit

class DishDescriptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var nutrientLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
