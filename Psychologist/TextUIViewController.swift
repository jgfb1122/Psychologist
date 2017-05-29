//
//  TextUIViewController.swift
//  Psychologist
//
//  Created by John Benton on 5/29/17.
//  Copyright © 2017 John Benton. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!{
        didSet{
            textView.text = text
        }
    }
    
    var text: String = ""{
        didSet{
            textView?.text = text
        }
    }
    
    override var preferredContentSize: CGSize{
        get{
            if textView != nil && presentingViewController != nil{
                return textView.sizeThatFits(presentingViewController!.view.bounds.size)
            } else {
                return super.preferredContentSize
            }
        }
        set{ super.preferredContentSize = newValue}
    }

}
