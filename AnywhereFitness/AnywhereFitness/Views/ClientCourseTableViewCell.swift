//
//  ClientCourseTableViewCell.swift
//  AnywhereFitness
//
//  Created by Enzo Jimenez-Soto on 5/28/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import UIKit

class ClientCourseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addClassButton: UIButton!
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var instructorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var backendController = BackendController.shared
    var course: Course? {
        didSet {
            updateViews()
        }
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func updateViews() {
        guard let course = course else { return }
        classNameLabel.text = course.name
        instructorLabel.text = String(course.id)
        dateLabel.text = course.date
        timeLabel.text = course.startTime
        locationLabel.text = course.location
    }

}
