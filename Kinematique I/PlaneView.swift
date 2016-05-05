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

class PlaneView: UIView {
    
    let model = Model.sharedInstance
    
    func setOrigin(origin: CGPoint) {
        model.origin = origin
        setNeedsDisplay()
    }
    
    func addPoint(point: CGPoint) {
        model.points.append(point)
        setNeedsDisplay()
    }
    
    func clear() {
        model.origin = nil
        model.points.removeAll()
        setNeedsDisplay()
    }
    
    private func _addAxes(context: CGContext, forOrigin origin: CGPoint, frameSize size: CGSize) {
        CGContextMoveToPoint(context, origin.x, 0)
        CGContextAddLineToPoint(context, origin.x, size.height)
        CGContextMoveToPoint(context, 0, origin.y)
        CGContextAddLineToPoint(context, size.width, origin.y)
    }
    
    private func _addCircle(context: CGContext, atPoint point: CGPoint) {
        let circleRect = CGRectMake(point.x - pointRadius, point.y - pointRadius, 2 * pointRadius, 2 * pointRadius)
        CGContextAddEllipseInRect(context, circleRect)
    }
    
    private func _drawVector(context: CGContext, length: CGFloat) {
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
    }
    
    private func _addVector(context: CGContext, fromOrigin origin: CGPoint, toPoint point: CGPoint) {
        let dy = point.y - origin.y
        let dx = point.x - origin.x
        let length: CGFloat = sqrt(dx * dx + dy * dy)
        let angle: CGFloat = atan2(dy, dx)
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, origin.x, origin.y)
        CGContextRotateCTM(context, angle)
        _drawVector(context, length: length)
        CGContextRestoreGState(context)
    }

    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!

        // Add axes if the origin has been set.
        if let origin = model.origin {
            CGContextSetFillColorWithColor(context, axesStrokeColor)
            CGContextSetLineWidth(context, axesWidth)
            CGContextBeginPath(context)
            _addAxes(context, forOrigin: origin, frameSize: frame.size)
            CGContextDrawPath(context, .Stroke)
        }

        // Add the points as filled gray circles with a thin stroke
        CGContextBeginPath(context)
        CGContextSetFillColorWithColor(context, pointsFillColor)
        CGContextSetStrokeColorWithColor(context, pointsStrokeColor)
        CGContextSetLineWidth(context, pointsStrokeWidth)
        for point in model.points {
            CGContextBeginPath(context)
            _addCircle(context, atPoint: point)
            CGContextDrawPath(context, .FillStroke)

        }
        CGContextDrawPath(context, .FillStroke)
        
        // Add the vectors as red arrows
        CGContextBeginPath(context)
        CGContextSetFillColorWithColor(context, vectorFillColor)
        CGContextSetStrokeColorWithColor(context, vectorStrokeColor)
        CGContextSetLineWidth(context, vectorStrokeWidth)
        for point in model.points {
            CGContextBeginPath(context)
            _addVector(context, fromOrigin: model.origin!, toPoint: point)
            CGContextDrawPath(context, .FillStroke)
        }
        
    }

}
