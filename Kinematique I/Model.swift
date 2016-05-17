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
    
    var allDifferences: [Difference] {
        var differences: [Difference] = []
        for i in 0..<points.count - 1 {
            differences.append(Difference(from:i, to:i + 1))
        }
        return differences
    }
    
}

// In principle, the difference between any to vectors can be shown.
// In actuality, `to` is always `from + 1`.
typealias Difference = (from: Int, to: Int)

class InterfaceState {
    
    static let sharedInstance = InterfaceState()
    
    var settingOrigin: Bool = true
    
    var selectedPositionPair: Difference? = nil
    
    var selectedVelocityPair: Difference? = nil

    var tracerResetTime: CFAbsoluteTime! = nil
    
    var tracerTimeInterval: CFTimeInterval = 0

    var showingParabolic: Bool = false
    
    var showingVelocities: Bool = false
    
    var showingAccelerations: Bool = false
    
    var selectedPositionPairs: [Difference] {
        if let difference = selectedPositionPair {
            return [difference]
        } else {
            return []
        }
    }
    
    var selectedVelocityPairs: [Difference] {
        if let difference = selectedVelocityPair {
            return [difference]
        } else {
            return []
        }
    }
    
}
