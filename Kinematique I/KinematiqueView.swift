//
//  KinematiqueView.swift
//  Kinematique I
//
//  Created by Brian Hill on 5/17/16.
//  Copyright © 2016 Kinematique. All rights reserved.
//

import UIKit

class KinematiqueView: UIView {
    
    // First we have code for drawing circles, used by both the tracer view and the positions view.
    
    var _circleFillColor: CGColor? = nil
    var _circleStrokeColor: CGColor? = nil
    var _circleStrokeWidth: CGFloat? = nil
    
    func setCircleAttributes(circleFillColor circleFillColor: CGColor, circleStrokeColor: CGColor, circleStrokeWidth: CGFloat) {
        _circleFillColor = circleFillColor
        _circleStrokeColor = circleStrokeColor
        _circleStrokeWidth = circleStrokeWidth
    }
    
    func addCircle(atPoint point: CGPoint, withRadius radius: CGFloat, alpha: CGFloat) {
        guard let circleFillColor = _circleFillColor else {return }
        guard let circleStrokeColor = _circleStrokeColor else { return }
        guard let circleStrokeWidth = _circleStrokeWidth else { return }
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let circleRect = CGRectMake(point.x - radius, point.y - radius, 2 * radius, 2 * radius)
        CGContextSetFillColorWithColor(context, circleFillColor)
        CGContextSetStrokeColorWithColor(context, circleStrokeColor)
        CGContextSetLineWidth(context, circleStrokeWidth)
        CGContextSetAlpha(context, alpha)
        CGContextBeginPath(context)
        CGContextAddEllipseInRect(context, circleRect)
        CGContextDrawPath(context, .FillStroke)
    }

}
