//
//  InstructorCourseTableViewCell.swift
//  AnywhereFitness
//
//  Created by Enzo Jimenez-Soto on 5/27/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import UIKit

class InstructorCourseTableViewCell: UITableViewCell {
    
    var backendController = BackendController.shared
    

    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateViews {
        
    }


}

