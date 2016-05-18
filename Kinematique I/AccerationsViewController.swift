//
//  AccerationsViewController.swift
//  Kinematique I
//
//  Created by Brian Hill on 5/17/16.
//  Copyright © 2016 Kinematique. All rights reserved.
//

import UIKit

class AccerationsViewController: UIViewController {
    
    @IBOutlet weak var allPositionsView: PositionsView!
    @IBOutlet weak var allVelocitiesView: VelocitiesView!
    @IBOutlet weak var selectedVelocitiesView: VelocitiesView!
    @IBOutlet weak var accelerationsView: AccelerationsView!
    
    @IBOutlet weak var earlierButton: UIBarButtonItem!
    @IBOutlet weak var laterButton: UIBarButtonItem!
    @IBOutlet weak var differencesButton: UIBarButtonItem!
    @IBOutlet weak var accelerationsButton: UIBarButtonItem!
    
    let userSelections = UserSelections.sharedInstance
    
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
        userSelections.showingAccelerations = false
        differencesButton.style = .Done
        accelerationsButton.style = .Plain
        accelerationsView.setNeedsDisplay()
    }
    
    @IBAction func accelerations(sender: UIBarButtonItem) {
        userSelections.showingAccelerations = true
        differencesButton.style = .Plain
        accelerationsButton.style = .Done
        accelerationsView.setNeedsDisplay()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if userSelections.selectedSecondOrderDifference == nil {
            userSelections.selectedSecondOrderDifference = SecondOrderDifference(from: 0, middle: 1, to: 2)
        }
        allPositionsView.allPositionsShowing = true
        allVelocitiesView.showingAllVelocities = true
        selectedVelocitiesView.showingSecondOrderDifference = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        earlierButton.enabled = canGoEarlier()
        laterButton.enabled = canGoLater()
        differencesButton.style = userSelections.showingAccelerations ? .Plain : .Done
        accelerationsButton.style = userSelections.showingAccelerations ? .Done : .Plain
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
