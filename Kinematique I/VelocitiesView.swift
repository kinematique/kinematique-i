//
//  VelocitiesView.swift
//  Kinematique I
//
//  Created by Brian Hill on 5/11/16.
//  Copyright © 2016 Kinematique. All rights reserved.
//

import UIKit

// Constants for drawing velocities
let differenceFillColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0.2, 0.3, 0.7, 0.9])
let differenceStrokeColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0.0, 0.0, 0.0, 1.0])

class VelocitiesView: PlaneView {
    
    func isSelectedIndex(index: Int) -> Bool {
        guard let difference = interfaceState.selectedDifference else { return false }
        return index == difference.from || index == difference.to
    }

    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        
        // Add axes if the origin has been set
        if let origin = dataModel.origin {
            CGContextSetFillColorWithColor(context, axesStrokeColor)
            CGContextSetLineWidth(context, axesWidth)
            addAxes(context, forOrigin: origin, frameSize: frame.size)
        }
        
        let pointsCount = dataModel.points.count
        
        // Add the vectors
        CGContextSetFillColorWithColor(context, vectorFillColor)
        CGContextSetStrokeColorWithColor(context, vectorStrokeColor)
        CGContextSetLineWidth(context, vectorStrokeWidth)
        for idx in 0..<pointsCount {
            if !isSelectedIndex(idx) { continue }
            let point = dataModel.points[idx]
            addVector(context, fromOrigin: dataModel.origin!, toPoint: point)
        }
        
        // Label the vectors
        let attributes: [String: AnyObject] = [
            NSForegroundColorAttributeName: labelTextColor,
            NSFontAttributeName: labelFont
        ]
        for idx in 0..<pointsCount {
            if !isSelectedIndex(idx) { continue }
            let point = dataModel.points[idx]
            let label = dataModel.labels[idx]
            let dy = point.y - dataModel.origin!.y
            let dx = point.x - dataModel.origin!.x
            let halfLength: CGFloat = sqrt(dx * dx + dy * dy) / 2
            let adjustedAngle: CGFloat = atan2(dy, dx) + labelProximity / halfLength
            labelVector(context, fromOrigin: dataModel.origin!, adjustedAngle: adjustedAngle, halfLength: halfLength, attributes: attributes, label: label)
        }
        
        // Add the selected velocities
        CGContextSetFillColorWithColor(context, differenceFillColor)
        CGContextSetStrokeColorWithColor(context, differenceStrokeColor)
        CGContextSetLineWidth(context, vectorStrokeWidth)
        if let difference = interfaceState.selectedDifference {
            let fromPoint = dataModel.points[difference.from]
            let fromTime = dataModel.times[difference.from]
            let toPoint = dataModel.points[difference.to]
            let toTime = dataModel.times[difference.to]
            if interfaceState.showingVelocities {
                let deltaTime: CGFloat = CGFloat(toTime - fromTime)
                let delta = CGPointMake((toPoint.x - fromPoint.x) / deltaTime, (toPoint.y - fromPoint.y) / deltaTime)
                let fromPointPlusDelta = CGPointMake(fromPoint.x + delta.x, fromPoint.y + delta.y)
                addVector(context, fromOrigin: fromPoint, toPoint: fromPointPlusDelta)
            } else {
                addVector(context, fromOrigin: fromPoint, toPoint: toPoint)
            }
        }
        
    }

}
