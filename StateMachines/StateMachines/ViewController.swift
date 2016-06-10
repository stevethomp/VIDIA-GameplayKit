//
//  ViewController.swift
//  StateMachines
//
//  Created by Steven Thompson on 2016-06-08.
//  Copyright © 2016 stevethomp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var imageViews: [StatefulImageView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        for iv in imageViews {
            iv.userInteractionEnabled = true
            iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:))))
        }
    }

    func imageViewTapped(sender: UITapGestureRecognizer) {
        if let iv = sender.view as? StatefulImageView, stateMachine = iv.stateMachine {
            stateMachine.enterState(UploadState)
        }
    }
    
    @IBAction func resetTapped(sender: AnyObject) {
        imageViews.forEach { (iv) in
            iv.stateMachine?.enterState(ReadyState)
        }
    }
}

