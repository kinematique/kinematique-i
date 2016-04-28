//
//  ViewController.swift
//  Kinematique I
//
//  Created by Brian Hill on 4/22/16.
//  Copyright © 2016 Kinematique. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var setOrigin: UIBarButtonItem!
    @IBOutlet var addPoints: UIBarButtonItem!
    @IBOutlet var clear: UIBarButtonItem!
    @IBOutlet var next: UIBarButtonItem!
    
    var settingOrigin = true
    
    var planeView: PlaneView {
        return view as! PlaneView
    }
    
    @IBAction func toggleSettingOrigin(sender: UIBarButtonItem?) {
        if sender == nil || sender!.tag == 0 {
            if !settingOrigin {
                settingOrigin = true
                setOrigin.style = .Done
                addPoints.style = .Plain
            }
        } else {
            if settingOrigin {
                settingOrigin = false
                setOrigin.style = .Plain
                addPoints.style = .Done
            }
        }
    }
    
    @IBAction func clearAll(sender: UIBarButtonItem) {
        planeView.clearAll()
        toggleSettingOrigin(nil)
        clear.enabled = false
        addPoints.enabled = false
        next.enabled = false
    }
    
    @IBAction func viewTapped(sender: UITapGestureRecognizer) {
        let tapPoint: CGPoint = sender.locationOfTouch(0, inView: planeView)
        if settingOrigin {
            planeView.origin = tapPoint
            // once the origin has been set, the user can clear or add points
            clear.enabled = true
            addPoints.enabled = true
        } else {
            planeView.addPoint(tapPoint)
            // once the user has added points, they can hit next
            if !next.enabled {
                next.enabled = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()	
    }

}
