//
//  ViewController.swift
//  Psychologist
//
//  Created by John Benton on 5/26/17.
//  Copyright © 2017 John Benton. All rights reserved.
//

import UIKit

class PsychologistViewController: UIViewController {

    @IBAction func nothingButtonClick(_ sender: UIButton) {
        performSegue(withIdentifier: "Show Nothing Answer", sender:nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var destination = segue.destination as? UIViewController
        if let navCon = destination as? UINavigationController {
            destination = navCon.visibleViewController
        }
        
        if let hvc = destination as? HappinessViewController{
            if let identifier = segue.identifier{
                switch identifier {
                case "Show Saddest Answer": hvc.happiness = 0
                case "Show Happy Answer": hvc.happiness = 60
                case "Show Happiest Answer": hvc.happiness = 100
                default: hvc.happiness = 50
                }
            }
        }
    }
    
}

