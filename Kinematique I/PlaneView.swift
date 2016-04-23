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

class PlaneView: UIView {
    
    var origin: CGPoint? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var points = [CGPoint]() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    func addPoint(point: CGPoint) {
        points.append(point)
    }
    
    func clearAll() {
        origin = nil
        points.removeAll()
    }
    
    private func _addAxesForOrigin(context: CGContext, _ origin: CGPoint, _ size: CGSize) {
        CGContextMoveToPoint(context, origin.x, 0)
        CGContextAddLineToPoint(context, origin.x, size.height)
        CGContextMoveToPoint(context, 0, origin.y)
        CGContextAddLineToPoint(context, size.width, origin.y)
    }
    
    private func _addCircleForPoint(context: CGContext, _ point: CGPoint) {
        let circleRect = CGRectMake(point.x - pointRadius, point.y - pointRadius, 2 * pointRadius, 2 * pointRadius)
        CGContextAddEllipseInRect(context, circleRect)
    }

    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!

        // Add axes if the origin has been set.
        if let origin = origin {
            CGContextBeginPath(context)
            CGContextSetFillColorWithColor(context, axesStrokeColor)
            CGContextSetLineWidth(context, axesWidth)
            _addAxesForOrigin(context, origin, frame.size)
            CGContextDrawPath(context, .Stroke)
        }

        // Add the points as filled gray circles with a thin stroke
        CGContextBeginPath(context)
        CGContextSetFillColorWithColor(context, pointsFillColor)
        CGContextSetStrokeColorWithColor(context, pointsStrokeColor)
        CGContextSetLineWidth(context, pointsStrokeWidth)
        for point in points {
            _addCircleForPoint(context, point)
        }
        CGContextDrawPath(context, .FillStroke)
        
    }

}
