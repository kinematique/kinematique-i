//
//  PositionsView.swift
//  Kinematique I
//
//  Created by Brian Hill on 4/22/16.
//  Copyright © 2016 Kinematique. All rights reserved.
//

import UIKit

// Colors for drawing points
private let _pointsFillColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0.5, 0.5, 0.5, 0.9])!
private let _pointsStrokeColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0.0, 0.0, 0.0, 1.0])!

// Colors for drawing position vectors -- at the moment these are used by a sublass! FIXME!
let _positionVectorFillColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0.7, 0.0, 0.0, 0.9])!
let _positionVectorStrokeColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0.0, 0.0, 0.0, 1.0])!

// A constant for drawing short labels -- at the moment this is also used by a sublass! FIXME!
let _labelProximity: CGFloat = 24

class PositionsView: KinematiqueView {
    
    let interfaceState = InterfaceState.sharedInstance
    
    let dataModel = DataModel.sharedInstance

    override func drawRect(rect: CGRect) {
        
        guard let origin = dataModel.origin else { return }
        
        // Add the points
        setCircleAttributes(circleFillColor: _pointsFillColor, circleStrokeColor: _pointsStrokeColor)
        for point in dataModel.points {
            addCircle(atPoint: point, alpha: 1.0)
        }
        
        // Add the position vectors
        setVectorAttributes(vectorFillColor: _positionVectorFillColor, vectorStrokeColor: _positionVectorStrokeColor)
        for point in dataModel.points {
            addVector(fromOrigin: origin, toPoint: point)
        }
        
        // Add the labels
        for idx in 0..<dataModel.points.count {
            let point = dataModel.points[idx]
            let label = dataModel.labels[idx]
            let dy = point.y - origin.y
            let dx = point.x - origin.x
            let halfLength: CGFloat = sqrt(dx * dx + dy * dy) / 2
            let adjustedAngle: CGFloat = atan2(dy, dx) + _labelProximity / halfLength
            labelVector(fromOrigin: origin, adjustedAngle: adjustedAngle, halfLength: halfLength, label: label)
        }
        
    }

}
