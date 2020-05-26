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
    
    var backEndController = BackendController()

    @IBOutlet weak var clientInstructorSegue: UISegmentedControl!
    
    @IBOutlet weak var signUpLogInSegue: UISegmentedControl!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func clientInstructorSegmentedControl(_ sender: UISegmentedControl) {
    }
    
    @IBAction func signUpSignInSegementedControl(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            firstNameTextField.isHidden = false
        lastNameTextField.isHidden = false
            signUpButton.setTitle("Sign Up", for: .normal)
            
        case 1:
            firstNameTextField.isHidden = true
        lastNameTextField.isHidden = true
            
            signUpButton.setTitle("Sign In", for: .normal)
        default:
            break
        }
    }
    
    @IBAction func signUpSignIn(_ sender: UIButton) {
        
        
        guard let clientSegmentedControl = clientInstructorSegue,
            
           let firstName = firstNameTextField.text,
            
           let lastName = lastNameTextField.text,
            
           let email = emailTextField.text,
            
            let password = passwordTextField.text else {return}
        
        let clientIndex = clientSegmentedControl.selectedSegmentIndex
        
        let role = ClientType.allCases[clientIndex]
        
        backEndController.signUp(firstName: firstName, lastName: lastName, email: email, password: password, role: [role], completion: <#T##(Bool, URLResponse?, Error?) -> Void#>)
    }
    
    
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
