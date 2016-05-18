//
//  KinematiqueView.swift
//  Kinematique I
//
//  Created by Brian Hill on 5/17/16.
//  Copyright © 2016 Kinematique. All rights reserved.
//

import UIKit

private let _circleRadius: CGFloat = 10
private let _circleStrokeWidth: CGFloat = 1

private let _headWidth: CGFloat = 10
private let _nominalHeadLength: CGFloat = 20
private let _tailWidth: CGFloat = 4
private let _vectorStrokeWidth: CGFloat = 1

private let _labelTextColor = UIColor(white: 0.5, alpha: 1.0).CGColor
private let _labelFont = UIFont.systemFontOfSize(24)

private let _labelFontAttributes: [String: AnyObject] = [
    NSForegroundColorAttributeName: _labelTextColor,
    NSFontAttributeName: _labelFont
]

// This UIView subclass has one job -- to provide the drawing code for circles, vectors and labels so that its subclasses don't have to keep re-implementing it. Without this class, the positions view, the velocities view, and the accelerations view would all be bogged down with repetitious drawing code.

class KinematiqueView: UIView {
    
    // First we have code for drawing circles, used by both the tracer view and the positions view.
    
    private var _circleFillColor: CGColor? = nil
    private var _circleStrokeColor: CGColor? = nil
    
    func setCircleAttributes(circleFillColor circleFillColor: CGColor, circleStrokeColor: CGColor) {
        _circleFillColor = circleFillColor
        _circleStrokeColor = circleStrokeColor
    }
    
    func addCircle(atPoint point: CGPoint, alpha: CGFloat) {
        guard let circleFillColor = _circleFillColor else {return }
        guard let circleStrokeColor = _circleStrokeColor else { return }
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        CGContextSetFillColorWithColor(context, circleFillColor)
        CGContextSetStrokeColorWithColor(context, circleStrokeColor)
        CGContextSetLineWidth(context, _circleStrokeWidth)
        CGContextSetAlpha(context, alpha)
        
        CGContextBeginPath(context)
        let circleRect = CGRectMake(point.x - _circleRadius, point.y - _circleRadius, 2 * _circleRadius, 2 * _circleRadius)
        CGContextAddEllipseInRect(context, circleRect)
        CGContextDrawPath(context, .FillStroke)
    }
    
    // Then we have code for drawing vectors, used by the positions view, the velocities view and the accelerations view.
    
    private var _vectorFillColor: CGColor? = nil
    private var _vectorStrokeColor: CGColor? = nil
    
    func setVectorAttributes(vectorFillColor vectorFillColor: CGColor, vectorStrokeColor: CGColor) {
        _vectorFillColor = vectorFillColor
        _vectorStrokeColor = vectorStrokeColor
    }
    
    private func _addCanonicalVector(context: CGContext, length: CGFloat) {
        let headLength: CGFloat = _nominalHeadLength < length / 2 ? _nominalHeadLength : length / 2
        let bodyLength: CGFloat = length - headLength
        CGContextBeginPath(context)
        CGContextMoveToPoint(context, 0, _tailWidth / 2)
        CGContextAddLineToPoint(context, bodyLength, _tailWidth / 2)
        CGContextAddLineToPoint(context, bodyLength, _headWidth / 2)
        CGContextAddLineToPoint(context, length, 0)
        CGContextAddLineToPoint(context, bodyLength, -_headWidth / 2)
        CGContextAddLineToPoint(context, bodyLength, -_tailWidth / 2)
        CGContextAddLineToPoint(context, 0, -_tailWidth / 2)
        CGContextClosePath(context)
        CGContextDrawPath(context, .FillStroke)
    }
    
    func addVector(fromOrigin origin: CGPoint, toPoint point: CGPoint) {
        guard let vectorFillColor = _vectorFillColor else {return }
        guard let vectorStrokeColor = _vectorStrokeColor else { return }
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        CGContextSetFillColorWithColor(context, vectorFillColor)
        CGContextSetStrokeColorWithColor(context, vectorStrokeColor)
        CGContextSetLineWidth(context, _vectorStrokeWidth)
        
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
    
    // Finally we have the code for labeling vectors.
    
    func labelVector(fromOrigin origin: CGPoint, adjustedAngle: CGFloat, halfLength: CGFloat, label: String) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let attributedString = NSAttributedString(string: label, attributes: _labelFontAttributes)
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

}
