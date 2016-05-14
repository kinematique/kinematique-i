//
//  TracerView.swift
//  Kinematique I
//
//  Created by Brian Hill on 5/5/16.
//  Copyright © 2016 Kinematique. All rights reserved.
//

import UIKit

import CoreGraphics

// Circular motion parameters
let radius: CGFloat = 250.0
let period: CFTimeInterval = 10

// Parabolic motion parameters
let transitTime: CFTimeInterval = 8
let transitWidth: CGFloat = 600
let initialVerticalVelocity: CGFloat = 300
let verticalDeceleration: CGFloat = 2 * initialVerticalVelocity / CGFloat(transitTime)
let doOverTime: CFTimeInterval = 10
let initialAltitude: CGFloat = 40

// Constants for drawing tracer points
let tracerPointFillColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0.5, 0.5, 0.5, 0.9])
let tracerPointRadius: CGFloat = 10 // <== unused?!
let tracerPointStrokeColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0.0, 0.0, 0.0, 1.0])
let tracerPointStrokeWidth: CGFloat = 1
let shadowDuration: CFTimeInterval = 0.5
let shadowQuantity: Int = 7

class TracerView: UIView {
    
    let interfaceState = InterfaceState.sharedInstance
        
    private func _addCircle(context: CGContext, atPoint point: CGPoint) {
        let circleRect = CGRectMake(point.x - pointRadius, point.y - pointRadius, 2 * pointRadius, 2 * pointRadius)
        CGContextBeginPath(context)
        CGContextAddEllipseInRect(context, circleRect)
        CGContextDrawPath(context, .FillStroke)
    }
    
    func circularMotion(timeInterval: CFTimeInterval) -> CGPoint? {
        let angle = CGFloat(2) * CGFloat(M_PI) * CGFloat(timeInterval) / CGFloat(period)
        let x = radius * cos(angle) + frame.size.width / 2
        let y = frame.size.height / 2 - radius * sin(angle)
        return CGPointMake(x, y)
    }
    
    func parabolicMotion(timeInterval: CFTimeInterval) -> CGPoint? {
        let remainder = timeInterval % doOverTime
        if remainder < 0 || remainder > transitTime { return nil }
        let x: CGFloat = transitWidth * (CGFloat(remainder) / CGFloat(transitTime) - 1 / 2) + frame.size.width / 2
        let y: CGFloat = frame.size.height - initialVerticalVelocity * CGFloat(remainder) + verticalDeceleration * CGFloat(remainder) * CGFloat(remainder) / 2 - initialAltitude
        return CGPointMake(x, y)
    }
    
    override func drawRect(rect: CGRect) {
        
        // Add the tracer point and its shadows
        let context = UIGraphicsGetCurrentContext()!
        CGContextSetFillColorWithColor(context, tracerPointFillColor)
        CGContextSetStrokeColorWithColor(context, tracerPointStrokeColor)
        CGContextSetLineWidth(context, pointsStrokeWidth)
        for i in 0..<shadowQuantity {
            // Add the points as filled gray circles with a thin stroke
            let shadowFraction = CFTimeInterval(i) / CFTimeInterval(shadowQuantity)
            let shadowTime = shadowFraction * shadowDuration
            let shadowTimeInterval = interfaceState.tracerTimeInterval - shadowTime
            let point = interfaceState.showingParabolic ? parabolicMotion(shadowTimeInterval) : circularMotion(shadowTimeInterval)
            CGContextSetAlpha(context, CGFloat(1 - shadowFraction))
            guard let knownPoint = point else { continue }
            _addCircle(context, atPoint: knownPoint)
        }
        
    }
    
}
