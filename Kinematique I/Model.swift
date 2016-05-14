//
//  Model.swift
//  Kinematique I
//
//  Created by Brian Hill on 5/4/16.
//  Copyright © 2016 Kinematique. All rights reserved.
//

import CoreGraphics


class DataModel {
    
    static let sharedInstance = DataModel()
    
    var origin: CGPoint?
    
    var initialTime: CFTimeInterval! = nil
    
    var points: [CGPoint] = []
    
    var times: [CFTimeInterval] = []
    
    var labels: [String] = []
    
}

// In principle, the difference between any to vectors can be shown.
// In actuality, `to` is always `from + 1`.
typealias Difference = (from: Int, to: Int)

class InterfaceState {
    
    static let sharedInstance = InterfaceState()
    
    var settingOrigin: Bool = true
    
    var selectedDifference: Difference? = nil
    
    var tracerResetTime: CFAbsoluteTime! = nil
    
    var tracerTimeInterval: CFTimeInterval = 0

    var showingParabolic: Bool = false
    
    var showingVelocities: Bool = false
    
}
