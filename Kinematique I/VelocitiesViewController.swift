//
//  VelocitiesViewController.swift
//  Kinematique I
//
//  Created by Brian Hill on 5/11/16.
//  Copyright © 2016 Kinematique. All rights reserved.
//

import UIKit

class VelocitiesViewController: UIViewController {
    
    @IBOutlet var velocitiesView: VelocitiesView!
    
    @IBOutlet var earlierButton: UIBarButtonItem!
    @IBOutlet var laterButton: UIBarButtonItem!
    @IBOutlet var differencesButton: UIBarButtonItem!
    @IBOutlet var veloctiesButton: UIBarButtonItem!
    
    func canGoEarlier() -> Bool {
        let velocitySelections = VelocitySelections.sharedInstance
        guard let firstSelection = velocitySelections.selections.first else { return false }
        return firstSelection.from > 0
    }
    
    func canGoLater() -> Bool {
        let velocitySelections = VelocitySelections.sharedInstance
        guard let lastSelection = velocitySelections.selections.last else { return false }
        return lastSelection.to < DataModel.sharedInstance.points.count - 1
    }
    
    func _earlier() {
        if !canGoEarlier() { return }
        let velocitySelections = VelocitySelections.sharedInstance
        guard let firstSelection = velocitySelections.selections.first else { return }
        velocitySelections.selections.removeFirst()
        let newDifference = (from: firstSelection.from - 1, to: firstSelection.to - 1)
        velocitySelections.selections.insert(newDifference, atIndex: 0)
        laterButton.enabled = true
        earlierButton.enabled = canGoEarlier()
        velocitiesView.setNeedsDisplay()
    }
        
    func _later() {
        if !canGoLater() { return }
        let velocitySelections = VelocitySelections.sharedInstance
        guard let lastSelection = velocitySelections.selections.last else { return }
        velocitySelections.selections.removeLast()
        let newDifference = (from: lastSelection.from + 1, to: lastSelection.to + 1)
        velocitySelections.selections.append(newDifference)
        laterButton.enabled = canGoLater()
        earlierButton.enabled = true
        velocitiesView.setNeedsDisplay()
    }
    
    @IBAction func earlier(sender: UIBarButtonItem) {
        _earlier()
    }
    
    @IBAction func later(sender: UIBarButtonItem) {
        _later()
    }
    
    @IBAction func differences(sender: UIBarButtonItem) {
        VelocitySelections.sharedInstance.showingVelocities = false
        differencesButton.style = .Done
        veloctiesButton.style = .Plain
        velocitiesView.setNeedsDisplay()
    }
    
    @IBAction func velocities(sender: UIBarButtonItem) {
        VelocitySelections.sharedInstance.showingVelocities = true
        differencesButton.style = .Plain
        veloctiesButton.style = .Done
        velocitiesView.setNeedsDisplay()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if velocitiesView.velocitySelections.selections.count == 0 {
            velocitiesView.addSelection((from:0, to:1))
        }
        earlierButton.enabled = canGoEarlier()
        laterButton.enabled = canGoLater()
        let showingVelocities = VelocitySelections.sharedInstance.showingVelocities
        differencesButton.style = showingVelocities ? .Plain : .Done
        veloctiesButton.style = showingVelocities ? .Done : .Plain
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
