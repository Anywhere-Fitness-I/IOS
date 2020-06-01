//
//  ClientLogInViewController.swift
//  AnywhereFitness
//
//  Created by Enzo Jimenez-Soto on 5/26/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import UIKit

enum ClientType: String, CaseIterable {
    case client
    case instructor
    
}


class LogInViewController: UIViewController {
    
    var backEndController = BackendController.shared
    
        @IBAction func unwindLoginSegue(segue: UIStoryboardSegue) { }
    
    @IBOutlet private var instructorClientLabel: UILabel!
    
    @IBOutlet private var clientInstructorSegue: UISegmentedControl!
    @IBOutlet private var signUpLogInSegue: UISegmentedControl!
    @IBOutlet private var firstNameTextField: UITextField!
    @IBOutlet private var lastNameTextField: UITextField!
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var signUpButton: UIButton!
    @IBOutlet private var signInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpLogInSegue.selectedSegmentIndex = 0
        signInButton.isHidden = true
        instructorClientLabel.text = "Client Portal"
        
        signInButton.layer.cornerRadius = 12
        signUpButton.layer.cornerRadius = 12
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func clientInstructorSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            instructorClientLabel.text = "Client Portal"
            
        case 1:
            instructorClientLabel.text = "Instructor Portal"
            
        default:
            break
        }
    }
    
    @IBAction func signUpSignInSegementedControl(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            firstNameTextField.isHidden = false
            lastNameTextField.isHidden = false
            signInButton.isHidden = true
            signUpButton.isHidden = false
            
            
        case 1:
            firstNameTextField.isHidden = true
            lastNameTextField.isHidden = true
            signUpButton.isHidden = true
            signInButton.isHidden = false
            
        default:
            break
        }
    }
    
    @IBAction func signUpSignIn(_ sender: UIButton) {
        
        
        guard let clientSegmentedControl = clientInstructorSegue,
            
            let firstName = firstNameTextField.text,
            
            let lastName = lastNameTextField.text,
            
            let email = emailTextField.text,
            
            let password = passwordTextField.text else { return }
        
        let clientIndex = clientSegmentedControl.selectedSegmentIndex
        
        let role = ClientType.allCases[clientIndex]
        
        backEndController.signUp(
        firstName: firstName, lastName: lastName, email: email, password: password, role: role.rawValue) { signUpResult, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.showAlertMessage(title: "Try Again", message: "Error Signing Up or Signing In", actiontitle: "Ok")
                    return
                    
                }
                if let response = response {
                    self.showAlertMessage(title: "Sucess", message: "Sign Up Sucessful", actiontitle: "Ok")
                    return
                }
                if signUpResult {
                    self.showAlertMessage(title: "Sucess", message: "Sign Up was sucessful", actiontitle: "Ok")
                    
                }
                return
            }
        }
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        
        guard let email = emailTextField.text,
            let clientSegmentedControl = clientInstructorSegue,
            let password = passwordTextField.text else { return }
        
        
        backEndController.signIn(email: email, password: password) { signInResult in
            DispatchQueue.main.async {
                if signInResult {
                    switch self.clientInstructorSegue.selectedSegmentIndex {
                    case 0:
                        self.performSegue(withIdentifier: "clientSegue", sender: self)
                        
                    case 1:
                        self.performSegue(withIdentifier: "signedInSegue", sender: self)
                        
                    default:
                        break
                    }
                    
                    self.showAlertMessage(title: "Sucess", message: "Sucess Logging In", actiontitle: "Ok")
                } else {
                    self.showAlertMessage(title: "Try Again", message: "Problem Signing In", actiontitle: "Ok")
                }
            }
        }
        
    }
    
    
    func showAlertMessage(title: String, message: String, actiontitle: String) {
        let endAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let endAction = UIAlertAction(title: actiontitle, style: .default) { (action: UIAlertAction ) in
        }
        endAlert.addAction(endAction)
        present(endAlert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    // override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
    //}
    
    
}
