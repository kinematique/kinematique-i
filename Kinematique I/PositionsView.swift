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

// Colors for drawing position vectors
private let _positionVectorFillColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0.7, 0.0, 0.0, 0.9])!
private let _positionVectorStrokeColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0.0, 0.0, 0.0, 1.0])!

// A constant for drawing short labels
private let _shortLabelProximity: CGFloat = 24

class PositionsView: KinematiqueView {
    
    var allPositionsShowing = false
    
    let userSelections = UserSelections.sharedInstance
    
    let dataModel = DataModel.sharedInstance
    
    func isSelectedIndex(index: Int) -> Bool {
        guard let difference = userSelections.selectedDifference else { return false }
        return index == difference.from || index == difference.to
    }

    override func drawRect(rect: CGRect) {
        
        guard let origin = dataModel.origin else { return }
        
        // Add the points
        setCircleAttributes(circleFillColor: _pointsFillColor, circleStrokeColor: _pointsStrokeColor)
        for idx in 0..<dataModel.points.count {
            if allPositionsShowing || isSelectedIndex(idx) {
                let point = dataModel.points[idx]
                addCircle(atPoint: point, alpha: 1.0)
            }
        }
        
        // Add the position vectors
        setVectorAttributes(vectorFillColor: _positionVectorFillColor, vectorStrokeColor: _positionVectorStrokeColor)
        for idx in 0..<dataModel.points.count {
            if allPositionsShowing || isSelectedIndex(idx) {
                addVector(fromOrigin: origin, toPoint: dataModel.points[idx])
            }
        }
        
        // Add the labels
        for idx in 0..<dataModel.points.count {
            if allPositionsShowing || isSelectedIndex(idx) {
                let point = dataModel.points[idx]
                let label = dataModel.labels[idx]
                let dy = point.y - origin.y
                let dx = point.x - origin.x
                let halfLength: CGFloat = sqrt(dx * dx + dy * dy) / 2
                let adjustedAngle: CGFloat = atan2(dy, dx) + _shortLabelProximity / halfLength
                labelVector(fromOrigin: origin, adjustedAngle: adjustedAngle, halfLength: halfLength, label: label)
            }
        }
        
    }

}
