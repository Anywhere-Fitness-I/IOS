//
//  FirstViewController.swift
//  AnywhereFitness
//
//  Created by Enzo Jimenez-Soto on 5/26/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import UIKit


class FirstViewController: UIViewController {

    @IBOutlet private var anywhereFitnessLabel: UILabel!
    @IBOutlet private var lookingForClassesLabel: UIButton!
    @IBOutlet private var coachingClassesLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    let strokeTextAttributes: [NSAttributedString.Key: Any] = [
        .strokeColor: UIColor.black,
        .foregroundColor: UIColor.systemIndigo,
        .strokeWidth: -2.2,
        ]

    anywhereFitnessLabel.attributedText = NSAttributedString(string: "ANYWHERE FITNESS", attributes: strokeTextAttributes)
        
        //lookingForClassesLabel.attributedText = NSAttributedString(string: "LOOKING FOR CLASSES", attributes: strokeTextAttributes)
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
    }
*/

}
