//
//  ViewController.swift
//  Kinematique I
//
//  Created by Brian Hill on 4/22/16.
//  Copyright © 2016 Kinematique. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var setOriginButton: UIButton!
    
    @IBOutlet var addPointsButton: UIButton!
    
    var settingOrigin = true
    
    var planeView: PlaneView {
        return view as! PlaneView
    }
    
    @IBAction func toggleSettingOrigin(sender: UIButton) {
        addPointsButton.selected = settingOrigin
        settingOrigin = !settingOrigin
        setOriginButton.selected = settingOrigin
    }
    
    @IBAction func clearAll(sender: UIBarButtonItem) {
        planeView.clearAll()
    }
    
    @IBAction func viewTapped(sender: UITapGestureRecognizer) {
        let tapPoint: CGPoint = sender.locationOfTouch(0, inView: planeView)
        if settingOrigin {
            planeView.origin = tapPoint
        } else {
            planeView.addPoint(tapPoint)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Kinematique I"
    }

}
