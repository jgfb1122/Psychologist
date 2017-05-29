//
//  DiagnosedHappinessViewController.swift
//  Psychologist
//
//  Created by John Benton on 5/29/17.
//  Copyright © 2017 John Benton. All rights reserved.
//

import UIKit

class DiagnosedHappinessViewController: HappinessViewController, UIPopoverPresentationControllerDelegate{
    
    override var happiness: Int {
        didSet{
            diagnosticHistory += [happiness]
        }
    }
    
    private let defaults = UserDefaults.standard
    
    var diagnosticHistory: [Int]{
        get{ return defaults.object(forKey: History.DefaultsKey) as? [Int] ?? []}
        set{ defaults.set(newValue, forKey: History.DefaultsKey)}
    }
    
    private struct History{
        static let SegueIdentifier = "Show Diagnostic History"
        static let DefaultsKey = "DiagnossedHappinessViewController.History"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier{
            case History.SegueIdentifier:
                if let tvc = segue.destination as? TextViewController{
                    if let ppc = tvc.popoverPresentationController{
                        ppc.delegate = self
                    }
                    tvc.text = "\(diagnosticHistory)"
                }
            default: break
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}
