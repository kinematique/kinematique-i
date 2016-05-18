//
//  VelocitiesView.swift
//  Kinematique I
//
//  Created by Brian Hill on 5/11/16.
//  Copyright © 2016 Kinematique. All rights reserved.
//

import UIKit

// Colors for drawing velocity vectors
private let _velocityVectorFillColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0.2, 0.3, 0.7, 0.9])!
private let _velocityVectorStrokeColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0.0, 0.0, 0.0, 1.0])!

// A constant for drawing medium labels
private let _mediumLabelProximity: CGFloat = 42

class VelocitiesView: KinematiqueView {
    
    var showingSecondOrderDifference: Bool = false
    
    var showingAllVelocities: Bool = false
    
    let userSelections = UserSelections.sharedInstance
    
    let dataModel = DataModel.sharedInstance
    
    func isSelectedVelocityIndex(index: Int) -> Bool {
        if showingAllVelocities {
            return true
        } else if showingSecondOrderDifference {
            guard let secondOrderDifference = userSelections.selectedSecondOrderDifference else { return false }
            return index == secondOrderDifference.from || index == secondOrderDifference.middle
        } else {
            guard let difference = userSelections.selectedDifference else { return false }
            return index == difference.from
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        // Add the velocity vectors
        setVectorAttributes(vectorFillColor: _velocityVectorFillColor, vectorStrokeColor: _velocityVectorStrokeColor)
        for idx in 0..<dataModel.points.count - 1 {
            if isSelectedVelocityIndex(idx) {
                let fromPoint = dataModel.points[idx]
                let fromTime = dataModel.times[idx]
                let toPoint = dataModel.points[idx + 1]
                let toTime = dataModel.times[idx + 1]
                let deltaTime: CGFloat = showingSecondOrderDifference || userSelections.showingVelocities ? CGFloat(toTime - fromTime) : 1
                let delta = CGPointMake((toPoint.x - fromPoint.x) / deltaTime, (toPoint.y - fromPoint.y) / deltaTime)
                let fromPointPlusDelta = CGPointMake(fromPoint.x + delta.x, fromPoint.y + delta.y)
                addVector(fromOrigin: fromPoint, toPoint: fromPointPlusDelta)
            }
        }
        
//            // Label the selected difference or velocity
//            let label = "\(dataModel.labels[difference.from]) to \(dataModel.labels[difference.to])"
//            let halfLength: CGFloat = sqrt(delta.x * delta.x + delta.y * delta.y) / 2
//            let adjustedAngle: CGFloat = atan2(delta.y, delta.x) + _mediumLabelProximity / halfLength
//            labelVector(fromOrigin: fromPoint, adjustedAngle: adjustedAngle, halfLength: halfLength, label: label)
    }
    
}
