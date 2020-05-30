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
    
    var id: Int64?
    
    @IBAction func confirmBookingTapped(_ sender: UIButton) {
        guard let className =  classNameLabel.text,
            let course = course,
            let id = id,
            let classType = classTypeLabel.text,
            let intensity = intensityLabel.text,
            let instructor = instructorNameLabel.text,
            let date = dateLabel.text,
            let location = locationLabel.text,
            let duration = durationLabel.text,
            let description = descriptionLaebl.text
            else { return }
        
        let newCourse = Course(id: id, name: className,
                               type: classType,
                               date: date,
                               startTime: date,
                               duration: duration,
                               overview: description,
                               intensityLevel: intensity,
                               location: location,
                               maxClassSize: id)
        
        if backendController.isSignedIn {
        backendController.createReservation(course) { result in
                          DispatchQueue.main.async {
                              self.backendController.userCourse.append(newCourse)
                            
                          }
                      }
        } else {
            print(course)
        }
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
    func showAlertMessage(title: String, message: String, actiontitle: String) {
        let endAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let endAction = UIAlertAction(title: actiontitle, style: .default) { (action: UIAlertAction ) in
        }
        endAlert.addAction(endAction)
        present(endAlert, animated: true, completion: nil)
    }

}
