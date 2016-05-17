//
//  PositionsView.swift
//  Kinematique I
//
//  Created by Brian Hill on 4/22/16.
//  Copyright © 2016 Kinematique. All rights reserved.
//

import UIKit

// Constants for drawing points
let pointsFillColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0.5, 0.5, 0.5, 0.9])
let pointRadius: CGFloat = 10
let pointsStrokeColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0.0, 0.0, 0.0, 1.0])
let pointsStrokeWidth: CGFloat = 1

// Constants for drawing vectors
let vectorFillColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0.7, 0.0, 0.0, 0.9])
let vectorStrokeColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0.0, 0.0, 0.0, 1.0])
let headWidth: CGFloat = 10
let nominalHeadLength: CGFloat = 20
let tailWidth: CGFloat = 4
let vectorStrokeWidth: CGFloat = 1

// Constants for drawing labels
let labelProximity: CGFloat = 24
let labelTextColor = UIColor(white: 0.5, alpha: 1.0).CGColor
let labelFont = UIFont.systemFontOfSize(24)

class PositionsView: UIView {
    
    let interfaceState = InterfaceState.sharedInstance
    
    static var fullHeight: CGFloat = 1000 // a placeholder
    
    let dataModel = DataModel.sharedInstance
    
    private func _addCircle(context: CGContext, atPoint point: CGPoint) {
        let circleRect = CGRectMake(point.x - pointRadius, point.y - pointRadius, 2 * pointRadius, 2 * pointRadius)
        CGContextBeginPath(context)
        CGContextAddEllipseInRect(context, circleRect)
        CGContextDrawPath(context, .FillStroke)
    }
    
    private func _addCanonicalVector(context: CGContext, length: CGFloat) {
        let headLength: CGFloat = nominalHeadLength < length / 2 ? nominalHeadLength : length / 2
        let bodyLength: CGFloat = length - headLength
        CGContextBeginPath(context)
        CGContextMoveToPoint(context, 0, tailWidth / 2)
        CGContextAddLineToPoint(context, bodyLength, tailWidth / 2)
        CGContextAddLineToPoint(context, bodyLength, headWidth / 2)
        CGContextAddLineToPoint(context, length, 0)
        CGContextAddLineToPoint(context, bodyLength, -headWidth / 2)
        CGContextAddLineToPoint(context, bodyLength, -tailWidth / 2)
        CGContextAddLineToPoint(context, 0, -tailWidth / 2)
        CGContextClosePath(context)
        CGContextDrawPath(context, .FillStroke)
    }

    func addVector(context: CGContext, fromOrigin origin: CGPoint, toPoint point: CGPoint) {
        let dy = point.y - origin.y
        let dx = point.x - origin.x
        let length: CGFloat = sqrt(dx * dx + dy * dy)
        let angle: CGFloat = atan2(dy, dx)
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, origin.x, origin.y)
        CGContextRotateCTM(context, angle)
        _addCanonicalVector(context, length: length)
        CGContextRestoreGState(context)
    }
    
    func labelVector(context: CGContext, fromOrigin origin: CGPoint, adjustedAngle: CGFloat, halfLength: CGFloat, attributes: [String: AnyObject], label: String) {
        let attributedString = NSAttributedString(string: label, attributes: attributes)
        let line = CTLineCreateWithAttributedString(attributedString)
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, origin.x + halfLength * cos(adjustedAngle), origin.y + halfLength * sin(adjustedAngle))
        let transform = CGAffineTransformMakeScale(1, -1)
        CGContextConcatCTM(context, transform)
        let labelSize = CTLineGetImageBounds(line, context).size
        CGContextSetTextPosition(context, -labelSize.width / 2, -labelSize.height / 2)
        CTLineDraw(line, context)
        CGContextRestoreGState(context)
    }

    override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()!
        
        guard let origin = dataModel.origin else { return }
        
        // Add the points as filled gray circles with a thin stroke
        CGContextSetFillColorWithColor(context, pointsFillColor)
        CGContextSetStrokeColorWithColor(context, pointsStrokeColor)
        CGContextSetLineWidth(context, pointsStrokeWidth)
        for point in dataModel.points {
            _addCircle(context, atPoint: point)
        }
        
        // Add the vectors
        CGContextSetFillColorWithColor(context, vectorFillColor)
        CGContextSetStrokeColorWithColor(context, vectorStrokeColor)
        CGContextSetLineWidth(context, vectorStrokeWidth)
        for point in dataModel.points {
            addVector(context, fromOrigin: dataModel.origin!, toPoint: point)
        }
        
        // Label the vectors
        let attributes: [String: AnyObject] = [
            NSForegroundColorAttributeName: labelTextColor,
            NSFontAttributeName: labelFont
        ]
        for idx in 0..<dataModel.points.count {
            let point = dataModel.points[idx]
            let label = dataModel.labels[idx]
            let dy = point.y - origin.y
            let dx = point.x - origin.x
            let halfLength: CGFloat = sqrt(dx * dx + dy * dy) / 2
            let adjustedAngle: CGFloat = atan2(dy, dx) + labelProximity / halfLength
            labelVector(context, fromOrigin: origin, adjustedAngle: adjustedAngle, halfLength: halfLength, attributes: attributes, label: label)
        }
        
    }

}
