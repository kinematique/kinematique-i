//
//  TracerView.swift
//  Kinematique I
//
//  Created by Brian Hill on 5/5/16.
//  Copyright © 2016 Kinematique. All rights reserved.
//

import UIKit

import CoreGraphics

let radius: CGFloat = 275.0
let period: CFTimeInterval = 10

// Constants for drawing tracer points
let tracerPointFillColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0.5, 0.5, 0.5, 0.9])
let tracerPointRadius: CGFloat = 10 // <== unused?!
let tracerPointStrokeColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0.0, 0.0, 0.0, 1.0])
let tracerPointStrokeWidth: CGFloat = 1
let shadowDuration: CFTimeInterval = 0.5
let shadowQuantity: Int = 7

class TracerView: UIView {
    
    var timeInterval: CFTimeInterval? = nil
    
    private func _addCircle(context: CGContext, atPoint point: CGPoint) {
        let circleRect = CGRectMake(point.x - pointRadius, point.y - pointRadius, 2 * pointRadius, 2 * pointRadius)
        CGContextBeginPath(context)
        CGContextAddEllipseInRect(context, circleRect)
        CGContextDrawPath(context, .FillStroke)
    }
    
    override func drawRect(rect: CGRect) {
        
        // The time interval is supposed to be set by the display link in the view controller
        guard let timeInterval = timeInterval else {
            return
        }
        
        // Add the tracer point and its shadows
        let context = UIGraphicsGetCurrentContext()!
        CGContextSetFillColorWithColor(context, tracerPointFillColor)
        CGContextSetStrokeColorWithColor(context, tracerPointStrokeColor)
        CGContextSetLineWidth(context, pointsStrokeWidth)
        for i in 0..<shadowQuantity {
            // Add the points as filled gray circles with a thin stroke
            let shadowFraction = CFTimeInterval(i) / CFTimeInterval(shadowQuantity)
            let shadowTime = shadowFraction * shadowDuration
            let angle = CGFloat(2) * CGFloat(M_PI) * CGFloat(timeInterval - shadowTime) / CGFloat(period)
            let x = radius * cos(angle) + frame.size.width / 2
            let y = radius * sin(angle) + frame.size.height / 2
            let point = CGPointMake(x, y)
            CGContextSetAlpha(context, CGFloat(1 - shadowFraction))
            _addCircle(context, atPoint: point)
        }
        
    }
    
}
