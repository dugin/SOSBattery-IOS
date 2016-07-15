//
//  CustomCell.swift
//  SOSBattery
//
//  Created by Rodrigo Dugin on 09/07/16.
//  Copyright © 2016 Point-Break Apps. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

         @IBOutlet weak var nameStore: UILabel!
     @IBOutlet weak var logoStore: UIImageView!
     @IBOutlet weak var distStore: UILabel!
     @IBOutlet weak var workTimeStore: UILabel!
     @IBOutlet weak var bairroStore: UILabel!
     @IBOutlet weak var endStore: UILabel!
         
     
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
