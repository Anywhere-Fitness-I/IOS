//
//  CreateAClassViewController.swift
//  AnywhereFitness
//
//  Created by Enzo Jimenez-Soto on 5/27/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import UIKit

class CreateAClassViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let context = CoreDataStack.shared.mainContext

    
    var typePicker = UIPickerView()
    var intensityPicker = UIPickerView()
    var durationPicker = UIPickerView()
    var typeData = ["Choose a workout", "Long Distance Running", "Cycling", "Cardio", "Strength Training", "Yoga", "Sprinting" ]
    var intensityData = ["Choose an intensity", "Light", "Medium", "Hard"]
    var durationData = ["Choose a duration", "20 minutes", "30 minutes", "40 minutes", "50 minutes", "60 minutes", "70 minutes", "80 minutes", "90 minutes" ]
    

     // MARK: - Outlets
        
    @IBOutlet private var classNameTextField: UITextField!
    @IBOutlet private var instructorNameTextField: UITextField!
    @IBOutlet private var locationTextField: UITextField!
    @IBOutlet private var classTypeTextField: UITextField!
    @IBOutlet private var intensityLevelTextField: UITextField!
    @IBOutlet private var classDurationTextField: UITextField!
    @IBOutlet private var maxClassSizeTextField: UITextField!
    @IBOutlet private var classDescriptionTextView: UITextView!
    @IBOutlet private var datePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            typePicker.delegate = self
              intensityPicker.delegate = self
              typePicker.dataSource = self
              intensityPicker.dataSource = self
              durationPicker.delegate = self
              durationPicker.dataSource = self
              typePicker.tag = 1
              intensityPicker.tag = 2
              durationPicker.tag = 3
              classTypeTextField.inputView = typePicker
              intensityLevelTextField.inputView = intensityPicker
              classDurationTextField.inputView = durationPicker
              datePicker.minuteInterval = 15

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Methods & Functions
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        
        guard let className = classNameTextField.text, !className.isEmpty else { return }
        guard let instructorName = instructorNameTextField.text, !instructorName.isEmpty else { return }
        guard let location = locationTextField.text, !location.isEmpty else { return }
        guard let type = classTypeTextField.text, !type.isEmpty else { return }
        guard let intensity = intensityLevelTextField.text, !intensity.isEmpty else { return }
        guard let duration = classDurationTextField.text, !duration.isEmpty else { return }
        guard let maxClassSize = maxClassSizeTextField.text, !maxClassSize.isEmpty else { return }
        guard let classSize = Int64(maxClassSize) else { return }
        guard let aDescription = classDescriptionTextView.text, !description.isEmpty else { return }
        let newDate = datePicker.date
    }
    
    
      func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
              if pickerView.tag == 1 {
                  return typeData.count
              } else if pickerView.tag == 2 {
                  return intensityData.count
              } else {
                  return durationData.count
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
             } else {
                 return durationData[row]
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
      }
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
