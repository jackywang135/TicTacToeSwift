//
//  ViewController.swift
//  TicTacToe
//
//  Created by Jacky Wang on 10/28/14.
//  Copyright (c) 2014 JACKYWANG. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    var arrayOfLines : [Line] {
        get {
            let screenHeight = CGFloat(UIScreen.mainScreen().bounds.height)
            let screenWidth = CGFloat(UIScreen.mainScreen().bounds.width)
            
            let lineVerticalLeft = Line(point1: CGPointMake(screenWidth/3, 0), point2: CGPointMake(screenWidth/3, screenHeight))
            let lineVerticalRight = Line(point1: CGPointMake(screenWidth*2/3, 0), point2: CGPointMake(screenWidth*2/3, screenHeight))
            let lineHorizonatalTop = Line(point1: CGPointMake(0, screenHeight/3), point2: CGPointMake(screenWidth, screenHeight/3))
            let lineHorizontalBottom = Line(point1: CGPointMake(0, screenHeight*2/3), point2: CGPointMake(screenWidth, screenHeight*2/3))
            
            return [lineHorizonatalTop, lineHorizontalBottom, lineVerticalLeft, lineVerticalRight]
        }
    }
 

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        drawLines(0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func drawLines(lineCount:Int) {
        
        var count = lineCount
        let line = arrayOfLines[count]
        
            let lineShapeLayer = CAShapeLayer()
            lineShapeLayer.path = line.getCGPath()
            lineShapeLayer.lineWidth = CGFloat(15)
            lineShapeLayer.strokeColor = UIColor.blackColor().CGColor
            self.view.layer.addSublayer(lineShapeLayer)
            
            let pencilImage = UIImage(named: "Pencil")
            var pencilLayer = CALayer()
            pencilLayer.contents = pencilImage!.CGImage
            pencilLayer.anchorPoint = CGPointMake(0, 0)
            pencilLayer.frame = CGRectMake(0, 0, pencilImage!.size.width, pencilImage!.size.height)
            
            lineShapeLayer.addSublayer(pencilLayer)
            
            var lineAnimation = CABasicAnimation(keyPath: "strokeEnd")
            lineAnimation.duration = 0.5
            lineAnimation.fromValue = 0
            lineAnimation.toValue = 1
            
            var penAnimation = CAKeyframeAnimation(keyPath: "position")
            penAnimation.duration = lineAnimation.duration
            penAnimation.fillMode = kCAFillModeForwards
            penAnimation.calculationMode = kCAAnimationCubicPaced
            penAnimation.path = lineShapeLayer.path

        
            CATransaction.begin()
            
            CATransaction.setCompletionBlock{
                pencilLayer.removeFromSuperlayer()
                count = count + 1
                if count < self.arrayOfLines.count {
                    self.drawLines(count)
                }
            }
            
            lineShapeLayer.addAnimation(lineAnimation, forKey: "strokeEnd")
            pencilLayer.addAnimation(penAnimation, forKey: "position")
            
            CATransaction.commit()
    }
}

