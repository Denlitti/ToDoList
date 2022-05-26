//
//  TaskCell.swift
//  To-Do Manager
//
//  Created by Данил Литти on 23.05.2022.
//

import UIKit

class TaskCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBOutlet var symbol: UILabel!
    @IBOutlet var title: UILabel!

}
