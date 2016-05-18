//
//  VelocitiesViewController.swift
//  Kinematique I
//
//  Created by Brian Hill on 5/11/16.
//  Copyright © 2016 Kinematique. All rights reserved.
//

import UIKit

class VelocitiesViewController: UIViewController {
    
    let userSelections = UserSelections.sharedInstance
    
    @IBOutlet weak var allPositionsView: PositionsView!
    @IBOutlet weak var selectedPositionsView: PositionsView!
    @IBOutlet weak var velocitiesView: VelocitiesView!
    
    @IBOutlet weak var earlierButton: UIBarButtonItem!
    @IBOutlet weak var laterButton: UIBarButtonItem!
    @IBOutlet weak var differencesButton: UIBarButtonItem!
    @IBOutlet weak var velocitiesButton: UIBarButtonItem!
    
    func canGoEarlier() -> Bool {
        guard let firstSelection = userSelections.selectedDifference else { return false }
        return firstSelection.from > 0
    }
    
    func canGoLater() -> Bool {
        guard let selectedDifference = userSelections.selectedDifference else { return false }
        return selectedDifference.to < DataModel.sharedInstance.points.count - 1
    }
    
    func _earlier() {
        if !canGoEarlier() { return }
        guard let selectedDifference = userSelections.selectedDifference else { return }
        let newDifference = (from: selectedDifference.from - 1, to: selectedDifference.to - 1)
        userSelections.selectedDifference = newDifference
        laterButton.enabled = true
        earlierButton.enabled = canGoEarlier()
        selectedPositionsView.setNeedsDisplay()
        velocitiesView.setNeedsDisplay()
    }
        
    func _later() {
        if !canGoLater() { return }
        guard let selectedDifference = userSelections.selectedDifference else { return }
        let newDifference = (from: selectedDifference.from + 1, to: selectedDifference.to + 1)
        userSelections.selectedDifference = newDifference
        laterButton.enabled = canGoLater()
        earlierButton.enabled = true
        selectedPositionsView.setNeedsDisplay()
        velocitiesView.setNeedsDisplay()
    }
    
    @IBAction func earlier(sender: UIBarButtonItem) {
        _earlier()
    }
    
    @IBAction func later(sender: UIBarButtonItem) {
        _later()
    }
    
    @IBAction func differences(sender: UIBarButtonItem) {
        userSelections.showingVelocities = false
        differencesButton.style = .Done
        velocitiesButton.style = .Plain
        velocitiesView.setNeedsDisplay()
    }
    
    @IBAction func velocities(sender: UIBarButtonItem) {
        userSelections.showingVelocities = true
        differencesButton.style = .Plain
        velocitiesButton.style = .Done
        velocitiesView.setNeedsDisplay()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        earlierButton.enabled = canGoEarlier()
        laterButton.enabled = canGoLater()
        differencesButton.style = userSelections.showingVelocities ? .Plain : .Done
        velocitiesButton.style = userSelections.showingVelocities ? .Done : .Plain
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if userSelections.selectedDifference == nil {
            userSelections.selectedDifference = (from: 0, to: 1)
        }
        allPositionsView.allPositionsShowing = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
