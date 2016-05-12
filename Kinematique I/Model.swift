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

    var initialTime: CFAbsoluteTime? = nil // this is set to the time that the first point is added    
    
    var points: [CGPoint] = []
    
    var times: [CFTimeInterval] = []
    
    var labels: [String] = []
    
}


typealias Difference = (from: Int, to: Int)

class VelocitySelections {
    
    static let sharedInstance = VelocitySelections()
    
    var selections: [Difference] = []
    
    var showingVelocities: Bool = false
    
}
