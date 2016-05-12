//
//  Model.swift
//  Kinematique I
//
//  Created by Brian Hill on 5/4/16.
//  Copyright © 2016 Kinematique. All rights reserved.
//

import CoreGraphics

class Model {
    
    static let sharedInstance = Model()
    
    var origin: CGPoint?

    var initialTime: CFAbsoluteTime? = nil // this is set to the time that the first point is added    
    
    var points: [CGPoint] = []
    
    var times: [CFTimeInterval] = []
    
    var labels: [String] = []
    
}
