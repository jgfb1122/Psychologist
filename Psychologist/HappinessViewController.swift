//
//  HappinessViewController.swift
//  Happiness
//
//  Created by John Benton on 3/25/17.
//  Copyright © 2017 John Benton. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController, FaceViewDataSource {
    
    @IBOutlet weak var faceView: FaceView!{
        didSet{
            faceView.dataSource = self
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: #selector(faceView.scale(gesture:))))
        }
    }
    @IBAction func test(_ sender: UITapGestureRecognizer) {
        print("test")
    }
    
    private struct Constants{
        static let HappinessGestureScale: CGFloat = 4
    }
    
    @IBAction func changeHappiness(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
            case .ended: fallthrough
            case .changed:
                let translation = sender.translation(in: faceView)
                let happinessChange = -Int(translation.y / Constants.HappinessGestureScale)
                if happinessChange != 0 {
                    happiness += happinessChange
                    sender.setTranslation(CGPoint.zero, in: faceView)
                }
            default: break
        }
    }
    
    var happiness: Int = 50 { //0 is the saddest and 100 is happiest
        didSet{
            happiness = min(max(happiness,0),100)
            print("happiness = \(happiness)")
            updateUI()
        }
    }
    
    private func updateUI(){
        faceView?.setNeedsDisplay()
        title = "\(happiness)"
    }
    
    func smilinessForFaceView(send: FaceView) -> Double? {
        return Double(happiness-50)/50
    }

}



