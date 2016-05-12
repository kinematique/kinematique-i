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
let shadowDuration: CFTimeInterval = 0.5
let shadowQuantity: Int = 7

// Constants for drawing tracer points
let tracerPointFillColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0.5, 0.5, 0.5, 0.9])
let tracerPointRadius: CGFloat = 10 // <== unused?!
let tracerPointStrokeColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0.0, 0.0, 0.0, 1.0])
let tracerPointStrokeWidth: CGFloat = 1

class TracerView: UIView {
    
    var timeInterval: CFTimeInterval? = nil
    
    private func _addCircle(context: CGContext, atPoint point: CGPoint) {
        let circleRect = CGRectMake(point.x - pointRadius, point.y - pointRadius, 2 * pointRadius, 2 * pointRadius)
        CGContextBeginPath(context)
        CGContextAddEllipseInRect(context, circleRect)
        CGContextDrawPath(context, .FillStroke)
    }
    
    override func drawRect(rect: CGRect) {
        
        guard let timeInterval = timeInterval else {
            return
        }
        
        let context = UIGraphicsGetCurrentContext()!
        
        for i in 0..<shadowQuantity {
            // Add the points as filled gray circles with a thin stroke
            let frameSize = self.frame.size
            let shadowFraction = CFTimeInterval(i) / CFTimeInterval(shadowQuantity)
            let shadowTime = shadowFraction * shadowDuration
            let angle = CGFloat(2) * CGFloat(M_PI) * CGFloat(timeInterval - shadowTime) / CGFloat(period)
            let x = radius * cos(angle)
            let y = radius * sin(angle)
            let point = CGPointMake(x + frameSize.width / 2, y + frameSize.height / 2)
            CGContextSetAlpha(context, CGFloat(1.0 - shadowFraction))
            CGContextSetFillColorWithColor(context, tracerPointFillColor)
            CGContextSetStrokeColorWithColor(context, tracerPointStrokeColor)
            CGContextSetLineWidth(context, pointsStrokeWidth)
            _addCircle(context, atPoint: point)
        }
        
    }
    
}
