//
//  BlockView.swift
//  TicTacToe
//
//  Created by Jacky Wang on 10/31/14.
//  Copyright (c) 2014 JACKYWANG. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics


enum Mark {
    case X, O, Empty
}

class BlockView : UIView {
    
    init(mark : Mark) {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    var mark : Mark = .Empty
    let animationDuration = 0.5
    let lineWidth : CGFloat = 7
    
    func draw (mark : Mark) {
        if mark == .X {
            self.mark = .X
            drawX()
        }
        if mark == .O {
            self.mark = .O
            drawO()
        }
    }
    
    func drawX() {
        
        var crossShapeLayer = CAShapeLayer()
        let center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
        let r : CGFloat = (self.bounds.size.height <= self.bounds.size.width) ? self.bounds.size.height * CGFloat(0.75/2) : self.bounds.size.width * CGFloat(0.75/2)
        
        let topLeftPoint = CGPointMake(center.x - r * sqrt(2)/2, center.y - r * sqrt(2)/2)
        let topRightPoint = CGPointMake(center.x + r * sqrt(2)/2, center.y - r * sqrt(2)/2)
        let botLeftPoint = CGPointMake(center.x - r * sqrt(2)/2, center.y + r * sqrt(2)/2)
        let botRightPoint = CGPointMake(center.x + r * sqrt(2)/2, center.y + r * sqrt(2)/2)
        
        var crossPath = UIBezierPath()
        crossPath.moveToPoint(topLeftPoint)
        crossPath.addLineToPoint(botRightPoint)
        crossPath.moveToPoint(topRightPoint)
        crossPath.addLineToPoint(botLeftPoint)
        
        crossShapeLayer.path = crossPath.CGPath
        crossShapeLayer.lineWidth = lineWidth
        crossShapeLayer.strokeColor = UIColor.blackColor().CGColor
        
        let pencilImage = UIImage(named: "Pencil")
        var pencilLayer = CALayer()
        pencilLayer.contents = pencilImage!.CGImage
        pencilLayer.anchorPoint = CGPointMake(0, 0)
        pencilLayer.frame = CGRectMake(-600, -600, pencilImage!.size.width, pencilImage!.size.height)
        
        var crossAnimation = CABasicAnimation(keyPath: "strokeEnd")
        crossAnimation.duration = animationDuration
        crossAnimation.fromValue = 0
        crossAnimation.toValue = 1
        
        var penAnimation = CAKeyframeAnimation(keyPath: "position")
        penAnimation.duration = crossAnimation.duration
        penAnimation.path = crossPath.CGPath
        penAnimation.fillMode = kCAFillModeBoth
        
        crossShapeLayer.addSublayer(pencilLayer)
        self.layer.addSublayer(crossShapeLayer)
        crossShapeLayer.addAnimation(crossAnimation, forKey: "drawCrossAnimation")
        pencilLayer.addAnimation(penAnimation, forKey: "drawPenAnimation")
        
        
    }
    
    func drawO() {
        
        var circleShapeLayer = CAShapeLayer()
        
        let r : CGFloat = (self.bounds.size.height <= self.bounds.size.width) ? self.bounds.size.height * CGFloat(0.75/2) : self.bounds.size.width * CGFloat(0.75/2)
        
        let center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
        
        var circlePath = UIBezierPath(arcCenter: center, radius: r, startAngle: 0, endAngle: CGFloat(2*(M_PI)), clockwise: true)
        circleShapeLayer.path = circlePath.CGPath
        circleShapeLayer.strokeColor = UIColor.blackColor().CGColor
        circleShapeLayer.fillColor = nil
        circleShapeLayer.lineWidth = lineWidth
        
        let pencilImage = UIImage(named: "Pencil")
        var pencilLayer = CALayer()
        pencilLayer.contents = pencilImage!.CGImage
        pencilLayer.anchorPoint = CGPointMake(0, 0)
        pencilLayer.frame = CGRectMake(-600, -600, pencilImage!.size.width, pencilImage!.size.height)
        
        var circleAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circleAnimation.fromValue = 0
        circleAnimation.toValue = 1
        circleAnimation.duration = animationDuration
        
        var penAnimation = CAKeyframeAnimation(keyPath: "position")
        penAnimation.path = circlePath.CGPath
        penAnimation.duration = circleAnimation.duration
        penAnimation.fillMode = kCAFillModeBoth
        
        self.layer.addSublayer(circleShapeLayer)
        circleShapeLayer.addSublayer(pencilLayer)
        
        circleShapeLayer.addAnimation(circleAnimation, forKey: "drawCircleAnimation")
        pencilLayer.addAnimation(penAnimation, forKey: "drawPenAnimation")
        
        
    }
    
}