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
    
    
    @IBOutlet weak var proccedPaymentButton: UIButton!
    
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var classTypeLabel: UILabel!
    @IBOutlet weak var intensityLabel: UILabel!
    @IBOutlet weak var instructorNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var descriptionLaebl: UILabel!
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
       
        }
        
        

        // Do any additional setup after loading the view.
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
   private func updateViews() {
        guard let course = course else { return }
        
        classNameLabel.text = course.name
        classTypeLabel.text = course.type
        intensityLabel.text = course.intensityLevel
        instructorNameLabel.text = String(course.instructorId)
        dateLabel.text = course.date
        locationLabel.text = course.location
        durationLabel.text = course.duration
        descriptionLaebl.text = course.description
    }
}

