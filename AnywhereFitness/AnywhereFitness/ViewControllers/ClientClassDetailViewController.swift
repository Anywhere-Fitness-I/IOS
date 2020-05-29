//
//  ClientClassViewController.swift
//  AnywhereFitness
//
//  Created by Enzo Jimenez-Soto on 5/26/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import UIKit

class ClientClassDetailViewController: UIViewController {
    
    var backendController = BackendController.shared
    var course: Course?
    

    @IBOutlet private var classNameLabel: UILabel!
    @IBOutlet private var classTypeLabel: UILabel!
    @IBOutlet private var intensityLabel: UILabel!
    @IBOutlet private var instructorNameLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var locationLabel: UILabel!
    @IBOutlet private var durationLabel: UILabel!
    @IBOutlet private var descriptionLaebl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
       
        }
 
   private func updateViews() {
        guard let course = course else { return }
        
        classNameLabel.text = course.name
        classTypeLabel.text = course.type
        intensityLabel.text = course.intensityLevel
        instructorNameLabel.text = String(course.id)
        dateLabel.text = course.date
        locationLabel.text = course.location
        durationLabel.text = course.duration
        descriptionLaebl.text = course.description
    }
}
