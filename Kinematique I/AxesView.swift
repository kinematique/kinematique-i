//
//  AxesView.swift
//  Kinematique I
//
//  Created by Brian Hill on 5/17/16.
//  Copyright © 2016 Kinematique. All rights reserved.
//

import UIKit

// Constants for drawing axes
let axesStrokeColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0.0, 0.0, 0.0, 1.0])
let axesWidth: CGFloat = 3

class AxesView: UIView {
    
    let dataModel = DataModel.sharedInstance
    
    private func _addAxes(context: CGContext, forOrigin origin: CGPoint) {
        let frameSize = frame.size
        CGContextSetFillColorWithColor(context, axesStrokeColor)
        CGContextSetLineWidth(context, axesWidth)
        CGContextBeginPath(context)
        CGContextMoveToPoint(context, origin.x, 0)
        CGContextAddLineToPoint(context, origin.x, frameSize.height)
        CGContextMoveToPoint(context, 0, origin.y)
        CGContextAddLineToPoint(context, frameSize.width, origin.y)
        CGContextDrawPath(context, .Stroke)
    }

    override func drawRect(rect: CGRect) {
        guard let origin = dataModel.origin else { return }
        guard let context = UIGraphicsGetCurrentContext() else { return }
        _addAxes(context, forOrigin: origin)
    }
    
}
