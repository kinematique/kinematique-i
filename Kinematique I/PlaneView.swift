//
//  PlaneView.swift
//  Kinematique I
//
//  Created by Brian Hill on 4/22/16.
//  Copyright © 2016 Kinematique. All rights reserved.
//

import UIKit

// Constants for drawing axes
let axesStrokeColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0.0, 0.0, 0.0, 1.0])
let axesWidth: CGFloat = 3

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
let labelCenteringAdjustment: CGFloat = 12

class PlaneView: UIView {
    
    static var fullHeight: CGFloat = 1000 // a placeholder
    
    var scale: CGFloat = 1.0
    
    let model = Model.sharedInstance
    
    func setOrigin(origin: CGPoint) {
        model.origin = origin
        setNeedsDisplay()
    }
    
    func addPoint(point: CGPoint) {
        model.points.append(point)
        model.times.append(CFAbsoluteTimeGetCurrent())
        model.labels.append(String(model.points.count))
        setNeedsDisplay()
    }
    
    func clear() {
        model.origin = nil
        model.points.removeAll()
        model.times.removeAll()
        model.labels.removeAll()
        setNeedsDisplay()
    }
    
    private func _addAxes(context: CGContext, forOrigin origin: CGPoint, frameSize size: CGSize) {
        CGContextBeginPath(context)
        CGContextMoveToPoint(context, origin.x, 0)
        CGContextAddLineToPoint(context, origin.x, size.height / scale)
        CGContextMoveToPoint(context, 0, origin.y)
        CGContextAddLineToPoint(context, size.width / scale, origin.y)
        CGContextDrawPath(context, .Stroke)
    }
    
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
        CGContextMoveToPoint(context, -tailWidth / 2, tailWidth / 2)
        CGContextAddLineToPoint(context, bodyLength, tailWidth / 2)
        CGContextAddLineToPoint(context, bodyLength, headWidth / 2)
        CGContextAddLineToPoint(context, length, 0)
        CGContextAddLineToPoint(context, bodyLength, -headWidth / 2)
        CGContextAddLineToPoint(context, bodyLength, -tailWidth / 2)
        CGContextAddLineToPoint(context, -tailWidth / 2, -tailWidth / 2)
        CGContextClosePath(context)
        CGContextDrawPath(context, .FillStroke)
    }

    private func _addVector(context: CGContext, fromOrigin origin: CGPoint, toPoint point: CGPoint) {
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
    
    private func _labelVector(context: CGContext, fromOrigin origin: CGPoint, adjustedAngle: CGFloat, halfLength: CGFloat, attributes: [String: AnyObject], label: String) {
        let attributedString = NSAttributedString(string: label, attributes: attributes)
        let line = CTLineCreateWithAttributedString(attributedString)
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, origin.x - labelCenteringAdjustment, origin.y + labelCenteringAdjustment)
        let transform = CGAffineTransformMakeScale(1, -1)
        CGContextConcatCTM(context, transform)
        CGContextSetTextPosition(context, halfLength * cos(adjustedAngle), -halfLength * sin(adjustedAngle))
        CTLineDraw(line, context)
        CGContextRestoreGState(context)
    }

    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        
        CGContextSaveGState(context)
        let transform = CGAffineTransformMakeScale(scale, scale)
        CGContextConcatCTM(context, transform)

        // Add axes if the origin has been set
        if let origin = model.origin {
            CGContextSetFillColorWithColor(context, axesStrokeColor)
            CGContextSetLineWidth(context, axesWidth)
            _addAxes(context, forOrigin: origin, frameSize: frame.size)
        }

        // Add the points as filled gray circles with a thin stroke
        for point in model.points {
            CGContextSetFillColorWithColor(context, pointsFillColor)
            CGContextSetStrokeColorWithColor(context, pointsStrokeColor)
            CGContextSetLineWidth(context, pointsStrokeWidth)
            _addCircle(context, atPoint: point)
        }
        
        // Add the vectors
        CGContextSetFillColorWithColor(context, vectorFillColor)
        CGContextSetStrokeColorWithColor(context, vectorStrokeColor)
        CGContextSetLineWidth(context, vectorStrokeWidth)
        for point in model.points {
            _addVector(context, fromOrigin: model.origin!, toPoint: point)
        }
        
        // Label the vectors
        let attributes: [String: AnyObject] = [
            NSForegroundColorAttributeName: labelTextColor,
            NSFontAttributeName: labelFont
        ]
        for i in 0..<model.points.count {
            let point = model.points[i]
            let label = model.labels[i]
            let dy = point.y - model.origin!.y
            let dx = point.x - model.origin!.x
            let halfLength: CGFloat = sqrt(dx * dx + dy * dy) / 2
            let adjustedAngle: CGFloat = atan2(dy, dx) + labelProximity / halfLength
            _labelVector(context, fromOrigin: model.origin!, adjustedAngle: adjustedAngle, halfLength: halfLength, attributes: attributes, label: label)
        }
        
        CGContextRestoreGState(context)
        
    }

}
