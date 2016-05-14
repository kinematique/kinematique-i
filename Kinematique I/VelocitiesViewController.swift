//
//  VelocitiesViewController.swift
//  Kinematique I
//
//  Created by Brian Hill on 5/11/16.
//  Copyright © 2016 Kinematique. All rights reserved.
//

import UIKit

class VelocitiesViewController: UIViewController {
    
    let interfaceState = InterfaceState.sharedInstance
    
    @IBOutlet var velocitiesView: VelocitiesView!
    
    @IBOutlet var earlierButton: UIBarButtonItem!
    @IBOutlet var laterButton: UIBarButtonItem!
    @IBOutlet var differencesButton: UIBarButtonItem!
    @IBOutlet var veloctiesButton: UIBarButtonItem!
    
    func canGoEarlier() -> Bool {
        guard let firstSelection = interfaceState.selectedDifference else { return false }
        return firstSelection.from > 0
    }
    
    func canGoLater() -> Bool {
        guard let selectedDifference = interfaceState.selectedDifference else { return false }
        return selectedDifference.to < DataModel.sharedInstance.points.count - 1
    }
    
    func _earlier() {
        if !canGoEarlier() { return }
        guard let selectedDifference = interfaceState.selectedDifference else { return }
        let newDifference = (from: selectedDifference.from - 1, to: selectedDifference.to - 1)
        interfaceState.selectedDifference = newDifference
        laterButton.enabled = true
        earlierButton.enabled = canGoEarlier()
        velocitiesView.setNeedsDisplay()
    }
        
    func _later() {
        if !canGoLater() { return }
        guard let selectedDifference = interfaceState.selectedDifference else { return }
        let newDifference = (from: selectedDifference.from + 1, to: selectedDifference.to + 1)
        interfaceState.selectedDifference = newDifference
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
        interfaceState.showingVelocities = false
        differencesButton.style = .Done
        veloctiesButton.style = .Plain
        velocitiesView.setNeedsDisplay()
    }
    
    @IBAction func velocities(sender: UIBarButtonItem) {
        interfaceState.showingVelocities = true
        differencesButton.style = .Plain
        veloctiesButton.style = .Done
        velocitiesView.setNeedsDisplay()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if interfaceState.selectedDifference == nil {
            interfaceState.selectedDifference = ((from:0, to:1))
        }
        earlierButton.enabled = canGoEarlier()
        laterButton.enabled = canGoLater()
        differencesButton.style = interfaceState.showingVelocities ? .Plain : .Done
        veloctiesButton.style = interfaceState.showingVelocities ? .Done : .Plain
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
