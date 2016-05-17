//
//  AccerationsViewController.swift
//  Kinematique I
//
//  Created by Brian Hill on 5/17/16.
//  Copyright © 2016 Kinematique. All rights reserved.
//

import UIKit

class AccerationsViewController: UIViewController {
    
    @IBOutlet weak var velocitiesView: VelocitiesView! = nil
    @IBOutlet weak var accelerationsView: AccelerationsView! = nil
    
    @IBOutlet weak var earlierButton: UIBarButtonItem!
    @IBOutlet weak var laterButton: UIBarButtonItem!
    @IBOutlet weak var differencesButton: UIBarButtonItem!
    @IBOutlet weak var accelerationsButton: UIBarButtonItem!
    
    let interfaceState = InterfaceState.sharedInstance
    
    func canGoEarlier() -> Bool {
        return false
    }
    
    func canGoLater() -> Bool {
        return false
    }
    
    func _earlier() {
    }
    
    func _later() {
    }
    
    @IBAction func earlier(sender: UIBarButtonItem) {
    }
    
    @IBAction func later(sender: UIBarButtonItem) {
    }
    
    @IBAction func differences(sender: UIBarButtonItem) {
        interfaceState.showingAccelerations = false
        differencesButton.style = .Done
        accelerationsButton.style = .Plain
        velocitiesView.setNeedsDisplay()
    }
    
    @IBAction func accelerations(sender: UIBarButtonItem) {
        interfaceState.showingAccelerations = true
        differencesButton.style = .Plain
        accelerationsButton.style = .Done
        // velocitiesView.setNeedsDisplay()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        velocitiesView.showingAllVelocities = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if interfaceState.selectedVelocityPair == nil {
            interfaceState.selectedVelocityPair = Difference(from:0, to:1)
        }
        earlierButton.enabled = canGoEarlier()
        laterButton.enabled = canGoLater()
        differencesButton.style = interfaceState.showingAccelerations ? .Plain : .Done
        accelerationsButton.style = interfaceState.showingAccelerations ? .Done : .Plain
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
