//
//  FaceView.swift
//  Happiness
//
//  Created by John Benton on 3/23/17.
//  Copyright © 2017 John Benton. All rights reserved.
//

import UIKit

protocol FaceViewDataSource: class{
    func smilinessForFaceView(send:FaceView) -> Double?
}

@IBDesignable
class FaceView: UIView
{
    @IBInspectable
    var lineWidth: CGFloat = 3 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var color: UIColor = UIColor.blue { didSet { setNeedsDisplay() } }
    @IBInspectable
    var scale: CGFloat = 0.90 { didSet { setNeedsDisplay() } }

    
    var faceCenter: CGPoint{
        return convert(center, from: superview)
    }
    
    var faceRadius: CGFloat{
        return min(bounds.size.width, bounds.size.height)/2 * scale
    }
    
    weak var dataSource: FaceViewDataSource?
    
    public func scale (gesture: UIPinchGestureRecognizer){
        if gesture.state == .changed {
            scale *= gesture.scale
            gesture.scale = 1
        }
    }
    
    private struct Scaling
    {
        static let FaceRadiusToEyeRadiusRatio:CGFloat = 10
        static let FaceRadiusToEyeOffSetRatio:CGFloat = 3
        static let FaceRadiusToEyeSeperationRatio:CGFloat = 1.5
        static let FaceRadiusToMouthWidthRatio:CGFloat = 1
        static let FaceRadiusToMouthHeightRatio:CGFloat = 3
        static let FaceRadiusToMouthOffSetRatio:CGFloat = 3
        
    }
    
    private enum Eye {case Left, Right}
    
    private func bezierPathForEye(whichEye:Eye) -> UIBezierPath
    {
        let eyeRadius = faceRadius / Scaling.FaceRadiusToEyeRadiusRatio
        let eyeVerticalOffset = faceRadius / Scaling.FaceRadiusToEyeOffSetRatio
        let eyeHorizontalSeperation = faceRadius / Scaling.FaceRadiusToEyeSeperationRatio
        
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffset
        switch whichEye{
            case .Left: eyeCenter.x -= eyeHorizontalSeperation / 2
            case .Right: eyeCenter.x += eyeHorizontalSeperation / 2
        }
        
        let path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2*Double.pi), clockwise: true)
        path.lineWidth = lineWidth
        return path
    }
    
    private func bezierPathForSmile(fractionOfMaxSmile:Double) -> UIBezierPath
    {
        let mouthWidth = faceRadius / Scaling.FaceRadiusToMouthWidthRatio
        let mouthHeight = faceRadius / Scaling.FaceRadiusToMouthHeightRatio
        let mouthVerticalOffSet = faceRadius / Scaling.FaceRadiusToMouthOffSetRatio
        
        let smileHeight = CGFloat(max(min(fractionOfMaxSmile , 1), -1)) * mouthHeight
        
        let start = CGPoint(x: faceCenter.x - mouthWidth/2 , y: faceCenter.y + mouthVerticalOffSet)
        let end = CGPoint(x: start.x + mouthWidth, y: start.y)
        let cp1 = CGPoint(x: start.x + mouthWidth / 3, y: start.y + smileHeight)
        let cp2 = CGPoint(x: end.x - mouthWidth / 3, y: cp1.y)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    
    override func draw(_ rect: CGRect){
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2*Double.pi), clockwise: true)
        facePath.lineWidth = lineWidth
        
        color.set()
        facePath.stroke()
        bezierPathForEye(whichEye: .Left).stroke()
        bezierPathForEye(whichEye: .Right).stroke()
        
        let smiliness = dataSource?.smilinessForFaceView(send: self) ?? 0.0
        let smilePath = bezierPathForSmile(fractionOfMaxSmile: smiliness)
        smilePath.stroke()
    }
    
}
