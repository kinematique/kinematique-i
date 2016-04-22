//
//  PlaneView.swift
//  Kinematique I
//
//  Created by Brian Hill on 4/22/16.
//  Copyright © 2016 Kinematique. All rights reserved.
//

import UIKit

let blackColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0.0, 0.0, 0.0, 1.0])
let grayColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0.5, 0.5, 0.5, 1.0])
let PointRadius: CGFloat = 10

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
    
    func addCircleAtPoint(context: CGContext, _ point: CGPoint) {
        let circleRect = CGRectMake(point.x - PointRadius, point.y - PointRadius, 2 * PointRadius, 2 * PointRadius)
        CGContextAddEllipseInRect(context, circleRect)
    }

    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!

        // Draw the origin as a filled black circle
        if let origin = origin {
            CGContextSetFillColorWithColor(context, blackColor)
            addCircleAtPoint(context, origin)
            CGContextDrawPath(context, .Fill)
        }

        // Draw all the other points as filled gray circles
        CGContextSetFillColorWithColor(context, grayColor)
        for point in points {
            addCircleAtPoint(context, point)
        }
        CGContextDrawPath(context, .Fill)
    }

}
