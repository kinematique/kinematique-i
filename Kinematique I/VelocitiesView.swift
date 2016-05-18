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

class VelocitiesView: PositionsView {
    
    var showingAllVelocities: Bool = false
    
    func isSelectedIndex(index: Int) -> Bool {
        if showingAllVelocities { return true }
        guard let difference = interfaceState.selectedPositionPair else { return false }
        return index == difference.from || index == difference.to
    }

    override func drawRect(rect: CGRect) {
        
        guard let origin = dataModel.origin else { return }
        
        if !showingAllVelocities {
        
            let pointsCount = dataModel.points.count
            
            // Add the selected vectors.
            setVectorAttributes(vectorFillColor: _positionVectorFillColor, vectorStrokeColor: _positionVectorStrokeColor)
            for idx in 0..<pointsCount {
                // Only draw the selected vectors.
                if !isSelectedIndex(idx) { continue }
                let point = dataModel.points[idx]
                addVector(fromOrigin: origin, toPoint: point)
            }
            
            // Label the selected vectors.
            
            for idx in 0..<pointsCount {
                if !isSelectedIndex(idx) { continue }
                let point = dataModel.points[idx]
                let label = dataModel.labels[idx]
                let dy = point.y - origin.y
                let dx = point.x - origin.x
                let halfLength: CGFloat = sqrt(dx * dx + dy * dy) / 2
                let adjustedAngle: CGFloat = atan2(dy, dx) + _labelProximity / halfLength
                labelVector(fromOrigin: origin, adjustedAngle: adjustedAngle, halfLength: halfLength, label: label)
            }
        }
        
        // Add and label the difference or velocity
        let differences = showingAllVelocities ? dataModel.allDifferences : interfaceState.selectedPositionPairs
        for difference in differences {
            let fromPoint = dataModel.points[difference.from]
            let fromTime = dataModel.times[difference.from]
            let toPoint = dataModel.points[difference.to]
            let toTime = dataModel.times[difference.to]
            let deltaTime: CGFloat = showingAllVelocities || interfaceState.showingVelocities ? CGFloat(toTime - fromTime) : 1
            let delta = CGPointMake((toPoint.x - fromPoint.x) / deltaTime, (toPoint.y - fromPoint.y) / deltaTime)
            let fromPointPlusDelta = CGPointMake(fromPoint.x + delta.x, fromPoint.y + delta.y)
            setVectorAttributes(vectorFillColor: _velocityVectorFillColor, vectorStrokeColor: _velocityVectorStrokeColor)
            addVector(fromOrigin: fromPoint, toPoint: fromPointPlusDelta)
            // Label the selected difference or velocity
            let label = "\(dataModel.labels[difference.from]) to \(dataModel.labels[difference.to])"
            let halfLength: CGFloat = sqrt(delta.x * delta.x + delta.y * delta.y) / 2
            // Note: using twice the proximity for these longer labels. Clean this up! FIXME!
            let adjustedAngle: CGFloat = atan2(delta.y, delta.x) + 2 * _labelProximity / halfLength
            labelVector(fromOrigin: fromPoint, adjustedAngle: adjustedAngle, halfLength: halfLength, label: label)
        }
    
    }

}
