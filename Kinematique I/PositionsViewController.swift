//
//  Positions   ViewController.swift
//  Kinematique I
//
//  Created by Brian Hill on 4/22/16.
//  Copyright © 2016 Kinematique. All rights reserved.
//

import UIKit

class PositionsViewController: UIViewController {
    
    @IBOutlet weak var tracerView: TracerView!
    @IBOutlet weak var axesView: AxesView!
    @IBOutlet weak var positionsView: PositionsView!
    
    @IBOutlet weak var setOriginButton: UIBarButtonItem!
    @IBOutlet weak var addPointsButton: UIBarButtonItem!
    @IBOutlet weak var clearButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var circularButton: UIBarButtonItem!
    @IBOutlet weak var parabolicButton: UIBarButtonItem!
    
    var displayLink: CADisplayLink! = nil
        
    let userSelections = UserSelections.sharedInstance
    let dataModel = DataModel.sharedInstance
    
    private func _settingOrigin() {
        if !userSelections.settingOrigin {
            userSelections.settingOrigin = true
            setOriginButton.style = .Done
            addPointsButton.style = .Plain
        }
    }
    
    private func _addingPoints() {
        if userSelections.settingOrigin {
            userSelections.settingOrigin = false
            setOriginButton.style = .Plain
            addPointsButton.style = .Done
        }
    }
    
    private func _clear(clearOrigin: Bool) {
        if clearOrigin {
            _settingOrigin()
            clearButton.enabled = false
            addPointsButton.enabled = false
            dataModel.origin = nil
            axesView.setNeedsDisplay()
        }
        dataModel.points.removeAll()
        dataModel.initialTime = nil
        dataModel.times.removeAll()
        dataModel.labels.removeAll()
        userSelections.selectedDifference = nil
        userSelections.selectedSecondOrderDifference = nil
        userSelections.showingVelocities = false
        userSelections.showingAccelerations = false
        positionsView.setNeedsDisplay()
        nextButton.enabled = false
    }
    
    @IBAction func circular(sender: UIBarButtonItem) {
        userSelections.showingParabolic = false
        circularButton.style = .Done
        parabolicButton.style = .Plain
        userSelections.tracerResetTime = CFAbsoluteTimeGetCurrent()
        userSelections.tracerTimeInterval = 0
        // clear invoked this way does not clear the origin
        _clear(false)
    }
    
    @IBAction func parabolic(sender: UIBarButtonItem) {
        userSelections.showingParabolic = true
        circularButton.style = .Plain
        parabolicButton.style = .Done
        userSelections.tracerResetTime = CFAbsoluteTimeGetCurrent()
        userSelections.tracerTimeInterval = 0
        // clear invoked this way does not clear the origin
        _clear(false)
    }
    
    @IBAction func setOrigin(sender: UIBarButtonItem) {
        _settingOrigin()
    }
    
    @IBAction func addPoints(sender: UIBarButtonItem) {
        _addingPoints()
    }

    @IBAction func clear(sender: UIBarButtonItem) {
        // clear invoked this way also clears the origin
        _clear(true)
    }
    
    func addPoint(point: CGPoint) {
        let now = CFAbsoluteTimeGetCurrent()
        if dataModel.points.count == 0 {
            dataModel.initialTime = now
        }
        dataModel.points.append(point)
        dataModel.times.append(now - dataModel.initialTime)
        let sanitizedPoint = userSelections.showingParabolic ? tracerView.parabolicMotion(now) : tracerView.circularMotion(now)
        dataModel.sanitizedPoints.append(sanitizedPoint)

        dataModel.labels.append(String(dataModel.points.count))
    }
    
    @IBAction func viewTapped(sender: UITapGestureRecognizer) {
        let tapPoint: CGPoint = sender.locationOfTouch(0, inView: positionsView)
        if userSelections.settingOrigin {
            dataModel.origin = tapPoint
            axesView.setNeedsDisplay()
            positionsView.setNeedsDisplay()
            // once the origin has been set, the user can clear or add points
            clearButton.enabled = true
            addPointsButton.enabled = true
        } else {
            addPoint(tapPoint)
            positionsView.setNeedsDisplay()
            // Once the user has made three points, they can hit next
            if dataModel.points.count == 3 {
                nextButton.enabled = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayLink = CADisplayLink(target:self, selector:#selector(prepareForVSync(_:)))
        displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode:NSRunLoopCommonModes)
        displayLink.paused = true
        positionsView.allPositionsShowing = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        userSelections.tracerResetTime = CFAbsoluteTimeGetCurrent()
        userSelections.tracerTimeInterval = 0
        tracerView.setNeedsDisplay()
        displayLink.paused = false
        circularButton.style = userSelections.showingParabolic ? .Plain : .Done
        parabolicButton.style = userSelections.showingParabolic ? .Done : .Plain
    }
    
    override func viewWillDisappear(animated: Bool) {
        displayLink.paused = true
        super.viewWillDisappear(animated)
    }
    
    func prepareForVSync(displayLink: CADisplayLink) {
        userSelections.tracerTimeInterval = CFAbsoluteTimeGetCurrent() + displayLink.duration - userSelections.tracerResetTime
        tracerView.setNeedsDisplay()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
