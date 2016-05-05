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
    
    var points: [CGPoint] = []
    
    var times: [CFTimeInterval] = []
    
    var labels: [String] = []
    
}
