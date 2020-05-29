//
//  ClientCourseTableViewCell.swift
//  AnywhereFitness
//
//  Created by Enzo Jimenez-Soto on 5/28/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import UIKit

class ClientCourseTableViewCell: UITableViewCell {
    
    
    private let timeFormatter: DateFormatter = {
       let formatter = DateFormatter()
       formatter.locale = Locale(identifier: "en_US")
       formatter.dateFormat = "h:mm a"
       return formatter
     }()
     
    @IBOutlet private var classNameLabel: UILabel!
    @IBOutlet private var instructorLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var locationLabel: UILabel!
    
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
        
        let timeString = timeFormatter.string(for: course.startTime)
        classNameLabel.text = course.name
        instructorLabel.text = String(course.id)
        dateLabel.text = course.date
        timeLabel.text = course.startTime
        locationLabel.text = course.location
        
        
    }

}
