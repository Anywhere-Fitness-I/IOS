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
    var id: Int64?
    
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
        
        
    @IBAction func bookingReserved(_ sender: UIButton) {
        
        guard let className = classNameLabel.text,
        let type = classTypeLabel.text,
            let course = course,
        let intensity = intensityLabel.text,
        let instructor = instructorNameLabel.text,
            let id = id,
        let date = dateLabel.text,
        let location = locationLabel.text,
        let duration = durationLabel.text,
            let description = descriptionLaebl.text else { return }
        
    
        
        backendController.createReservations(course: course, name: className, type: type, date: date, startTime: date, duration: duration, description: description, intensityLevel: intensity, location: location, maxClassSize: id) { error in
            if let error = error {
                NSLog("error in booking the reservation: \(error)")
                return
            }
            DispatchQueue.main.async {
                self.showAlertMessage(title: "Congratulations!", message: "Reservation Confirmed", actiontitle: "Ok")
            }
        }
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

