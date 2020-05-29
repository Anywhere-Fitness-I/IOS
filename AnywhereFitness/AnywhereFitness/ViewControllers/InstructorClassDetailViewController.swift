//
//  TeachingClassDetailViewController.swift
//  AnywhereFitness
//
//  Created by Enzo Jimenez-Soto on 5/28/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import UIKit

class InstructorClassDetailController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let context = CoreDataStack.shared.mainContext
    
    var course: Course?
    
    var backendController = BackendController.shared
    
    private let timeFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.locale = Locale(identifier: "en_US")
      formatter.dateFormat = "h:mm a"
      return formatter
    }()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()
    
    var classSizePicker = UIPickerView()
    var typePicker = UIPickerView()
    var intensityPicker = UIPickerView()
    var durationPicker = UIPickerView()
    var classSizeData = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
                         "11", "12", "13", "14", "15", "16", "17", "18", "19", "20",
                         "21", "22", "23", "24", "25", "26", "27", "28", "29", "30",
                         "31", "32", "33", "34", "35", "36", "37", "38", "39", "40"]
    var typeData = ["Choose a workout", "Long Distance Running", "Cycling", "Cardio", "Strength Training", "Yoga", "Sprinting" ]
    var intensityData = ["Choose an intensity", "Light", "Medium", "Hard"]
    var durationData = ["Choose a duration", "20 minutes", "30 minutes", "40 minutes", "50 minutes", "60 minutes", "70 minutes", "80 minutes", "90 minutes" ]
    
    func updateViews() {
        guard let course = course,
            let courseDate = course.date else { return }
        
        
        classNameTextField.text = course.name
        instructorNameTextField.text = String(course.instructorId)
        locationTextField.text = course.location
        classTypeTextField.text = course.type
        intensityLevelTextField.text = course.intensityLevel
        classDurationTextField.text = course.duration
        maxClassSizeTextField.text = String(course.maxClassSize)
        classDescriptionTextView.text = course.description
        var dateString = dateFormatter.string(from: datePicker.date)
        dateString = courseDate
        
        
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var fitnessImage: UIImageView!
    
    @IBOutlet private var classNameTextField: UITextField!
    @IBOutlet private var instructorNameTextField: UITextField!
    @IBOutlet private var locationTextField: UITextField!
    @IBOutlet private var classTypeTextField: UITextField!
    @IBOutlet private var intensityLevelTextField: UITextField!
    @IBOutlet private var classDurationTextField: UITextField!
    @IBOutlet private var maxClassSizeTextField: UITextField!
    @IBOutlet private var classDescriptionTextView: UITextView!
    @IBOutlet private var datePicker: UIDatePicker!
    
    
    @IBOutlet private var classNameLabel: UILabel!
    @IBOutlet private var instructorNameLabel: UILabel!
    @IBOutlet private var locationLabel: UILabel!
    @IBOutlet private var classLabel: UILabel!
    @IBOutlet private var intesityLabel: UILabel!
    @IBOutlet private var classDurationLabel: UILabel!
    @IBOutlet private var maxClassSizeLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typePicker.delegate = self
        intensityPicker.delegate = self
        typePicker.dataSource = self
        intensityPicker.dataSource = self
        durationPicker.delegate = self
        durationPicker.dataSource = self
        classSizePicker.delegate = self
        classSizePicker.dataSource = self
        typePicker.tag = 1
        intensityPicker.tag = 2
        durationPicker.tag = 3
        classSizePicker.tag = 4
        maxClassSizeTextField.inputView = classSizePicker
        classTypeTextField.inputView = typePicker
        intensityLevelTextField.inputView = intensityPicker
        classDurationTextField.inputView = durationPicker
        datePicker.minuteInterval = 15
        dismissPickerView()
        updateViews()
        
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.black,
            .foregroundColor: UIColor.white,
            .strokeWidth: -2.8,
            ]

        classNameLabel.attributedText = NSAttributedString(string: "Class Name:", attributes: strokeTextAttributes)
        instructorNameLabel.attributedText = NSAttributedString(string: "Instructor Name:", attributes: strokeTextAttributes)
        locationLabel.attributedText = NSAttributedString(string: "Location:", attributes: strokeTextAttributes)
        classLabel.attributedText = NSAttributedString(string: "Class Type:", attributes: strokeTextAttributes)
        intesityLabel.attributedText = NSAttributedString(string: "Intensity Level", attributes: strokeTextAttributes)
        classDurationLabel.attributedText = NSAttributedString(string: "Class Duration:", attributes: strokeTextAttributes)
        maxClassSizeLabel.attributedText = NSAttributedString(string: "Max Class Size:", attributes: strokeTextAttributes)
        descriptionLabel.attributedText = NSAttributedString(string: "Description:", attributes: strokeTextAttributes)
        dateLabel.attributedText = NSAttributedString(string: "Date:", attributes: strokeTextAttributes)
        
        fitnessImage.alpha = 0.7
        
        
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Methods & Functions
    @IBAction func editTapped(_ sender: UIBarButtonItem) {
        
        guard let course = course else { return }
        
        let dateString = dateFormatter.string(from: datePicker.date)
        let startTime = timeFormatter.string(from: datePicker.date)
        
        guard let className = classNameTextField.text, !className.isEmpty else { return }
        guard let instructorName = instructorNameTextField.text, !instructorName.isEmpty else { return }
        guard let location = locationTextField.text, !location.isEmpty else { return }
        guard let type = classTypeTextField.text, !type.isEmpty else { return }
        guard let intensity = intensityLevelTextField.text, !intensity.isEmpty else { return }
        guard let duration = classDurationTextField.text, !duration.isEmpty else { return }
        guard let maxClassSize = maxClassSizeTextField.text, !maxClassSize.isEmpty else { return }
        guard let classSize = Int64(maxClassSize) else { return }
        guard let description = classDescriptionTextView.text, !description.isEmpty else { return }
        
        
        if backendController.isSignedIn {
        backendController.updateCourse(at: course,
                                       name: className,
                                       type: type,
                                       date: dateString,
                                       startTime: startTime,
                                       duration: duration,
                                       description: description,
                                       intensityLevel: intensity,
                                       location: location,
                                       maxClassSize: classSize) { error in
            if let error = error {
                NSLog("Error editing class: \(error)")
                return
            }
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
        }
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return typeData.count
        } else if pickerView.tag == 2 {
            return intensityData.count
        } else if pickerView.tag == 3 {
            return durationData.count
        } else {
            return classSizeData.count
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return typeData[row]
        } else if pickerView.tag == 2 {
            return intensityData[row]
        } else if pickerView.tag == 3 {
            return durationData[row]
        } else {
            return classSizeData[row]
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            return  classTypeTextField.text = typeData[row]
        } else if pickerView.tag == 2 {
            return intensityLevelTextField.text = intensityData[row]
        } else if pickerView.tag == 3 {
            return classDurationTextField.text = durationData[row]
        } else {
            return maxClassSizeTextField.text = classSizeData[row]
        }
    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        intensityLevelTextField.inputAccessoryView = toolBar
        classTypeTextField.inputAccessoryView = toolBar
        classDurationTextField.inputAccessoryView = toolBar
        maxClassSizeTextField.inputAccessoryView = toolBar
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAlertMessage(title: String, message: String, actiontitle: String) {
        let endAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let endAction = UIAlertAction(title: actiontitle, style: .default) { (action: UIAlertAction ) in
        }
        endAlert.addAction(endAction)
        present(endAlert, animated: true, completion: nil)
    }
    

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


