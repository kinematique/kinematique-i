//
//  TracerViewController.swift
//  Kinematique I
//
//  Created by Brian Hill on 4/22/16.
//  Copyright © 2016 Kinematique. All rights reserved.
//

import UIKit

class TracerViewController: UIViewController {
    
    @IBOutlet var tracerView: TracerView!
    @IBOutlet var planeView: PlaneView!
    
    @IBOutlet var setOriginButton: UIBarButtonItem!
    @IBOutlet var addPointsButton: UIBarButtonItem!
    @IBOutlet var clearButton: UIBarButtonItem!
    @IBOutlet var nextButton: UIBarButtonItem!
    @IBOutlet var circularButton: UIBarButtonItem!
    @IBOutlet var parabolicButton: UIBarButtonItem!

    var settingOrigin = true
    
    var displayLink: CADisplayLink! = nil
    
    var viewAppearingTime: CFAbsoluteTime = 0.0
    
    private func _settingOrigin() {
        if !settingOrigin {
            settingOrigin = true
            setOriginButton.style = .Done
            addPointsButton.style = .Plain
        }
    }
    
    private func _addingPoints() {
        if settingOrigin {
            settingOrigin = false
            setOriginButton.style = .Plain
            addPointsButton.style = .Done
        }
    }
    
    @IBAction func circular(sender: UIBarButtonItem) {
        VelocitySelections.sharedInstance.showingParabolic = false
        circularButton.style = .Done
        parabolicButton.style = .Plain
        viewAppearingTime = CFAbsoluteTimeGetCurrent()
        tracerView.timeInterval = 0
        _clear(false)
    }
    
    @IBAction func parabolic(sender: UIBarButtonItem) {
        VelocitySelections.sharedInstance.showingParabolic = true
        circularButton.style = .Plain
        parabolicButton.style = .Done
        viewAppearingTime = CFAbsoluteTimeGetCurrent()
        tracerView.timeInterval = 0
        _clear(false)
    }
    
    @IBAction func setOrigin(sender: UIBarButtonItem) {
        _settingOrigin()
    }
    
    @IBAction func addPoints(sender: UIBarButtonItem) {
        _addingPoints()
    }
    
    func _clear(clearOrigin: Bool) {
        if clearOrigin {
            _settingOrigin()
            clearButton.enabled = false
            addPointsButton.enabled = false
        }
        planeView.clear(clearOrigin)
        nextButton.enabled = false
    }
    
    @IBAction func clear(sender: UIBarButtonItem) {
        _clear(true)
    }
    
    @IBAction func viewTapped(sender: UITapGestureRecognizer) {
        let tapPoint: CGPoint = sender.locationOfTouch(0, inView: planeView)
        if settingOrigin {
            planeView.setOrigin(tapPoint)
            // once the origin has been set, the user can clear or add points
            clearButton.enabled = true
            addPointsButton.enabled = true
        } else {
            planeView.addPoint(tapPoint)
            // once the user has added one or more points, they can hit next
            if !nextButton.enabled {
                nextButton.enabled = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayLink = CADisplayLink(target:self, selector:#selector(prepareForVSync(_:)))
        displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode:NSRunLoopCommonModes)
        displayLink.paused = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        viewAppearingTime = CFAbsoluteTimeGetCurrent()
        tracerView.timeInterval = 0
        tracerView.setNeedsDisplay()
        displayLink.paused = false
        circularButton.style = VelocitySelections.sharedInstance.showingParabolic ? .Plain : .Done
        parabolicButton.style = VelocitySelections.sharedInstance.showingParabolic ? .Done : .Plain
    }
    
    override func viewWillDisappear(animated: Bool) {
        displayLink.paused = true
        tracerView.timeInterval = nil
        super.viewWillDisappear(animated)
    }
    
    func prepareForVSync(displayLink: CADisplayLink) {
        let timeInterval = CFAbsoluteTimeGetCurrent() + displayLink.duration - viewAppearingTime
        tracerView.timeInterval = timeInterval
        tracerView.setNeedsDisplay()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
