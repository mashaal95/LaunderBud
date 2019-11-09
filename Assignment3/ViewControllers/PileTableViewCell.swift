//
//  PileTableViewCell.swift
//  Assignment3
//
//  Created by Mashaal on 5/11/19.
//  Copyright © 2019 Monash. All rights reserved.
//

import UIKit

// This class is responsible for initialising the UITableViewCell for the 'Pile' screen
class PileTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var colourImageView: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var rfidLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
