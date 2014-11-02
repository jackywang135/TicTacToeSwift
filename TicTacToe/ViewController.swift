//
//  ViewController.swift
//  TicTacToe
//
//  Created by Jacky Wang on 10/28/14.
//  Copyright (c) 2014 JACKYWANG. All rights reserved.
//

import UIKit
import QuartzCore

enum Turn {
    case Xturn, Oturn
}

enum GameStatus {
    case Xwin, Owin, tie, inconclusive
}

extension Turn {
    
    func switchTurn() -> Turn {
        switch self {
        case Xturn:
            return .Oturn
        case Oturn:
            return .Xturn
        }
    }
    
    func getMark() -> Mark {
        switch self {
        case Xturn:
            return .X
        case Oturn:
            return .O
        }
    }
}

class ViewController: UIViewController {

    required init(coder aDecoder: NSCoder) {
        turn = .Xturn
        gameStatus = .inconclusive
        
        super.init(coder: aDecoder)
        
    }
    
    var turn : Turn
    
    var gameStatus : GameStatus
    
    var arrayOfLines : [Line] {
        get {
            return setUpLines()
        }
    }
    
    let winningBlockCombination = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
    
    func setUpLines() -> [Line] {
        let screenHeight = CGFloat(UIScreen.mainScreen().bounds.height)
        let screenWidth = CGFloat(UIScreen.mainScreen().bounds.width)
        
        let lineVerticalLeft = Line(point1: CGPointMake(screenWidth/3, 0), point2: CGPointMake(screenWidth/3, screenHeight))
        let lineVerticalRight = Line(point1: CGPointMake(screenWidth*2/3, 0), point2: CGPointMake(screenWidth*2/3, screenHeight))
        let lineHorizonatalTop = Line(point1: CGPointMake(0, screenHeight/3), point2: CGPointMake(screenWidth, screenHeight/3))
        let lineHorizontalBottom = Line(point1: CGPointMake(0, screenHeight*2/3), point2: CGPointMake(screenWidth, screenHeight*2/3))
        
        return [lineHorizonatalTop, lineHorizontalBottom, lineVerticalLeft, lineVerticalRight]
    }
    
    @IBOutlet var blockViewCollection: Array <BlockView>!

    override func viewDidLoad() {
        super.viewDidLoad()
        drawLinesAnimation(0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tap(sender: UITapGestureRecognizer) {
        
        let point = sender.locationInView(self.view)
        var blockView = self.view.hitTest(point, withEvent:nil)!
        
        if let blockView = blockView as? BlockView {
            if blockView.mark == .Empty {
                blockView.draw(turn.getMark())
                turn = turn.switchTurn()
            }
        }
    }
    
    func createWinningCombo() {
        for blockview in blockViewCollection {
            
        }
    }
    
    func checkWin() {
        for blockview in blockViewCollection {

        }
    }
    
    func drawLinesAnimation(lineCount:Int) {
        
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
            pencilLayer.frame = CGRectMake(-600, -600, pencilImage!.size.width, pencilImage!.size.height)
        
            lineShapeLayer.addSublayer(pencilLayer)
            
            var lineAnimation = CABasicAnimation(keyPath: "strokeEnd")
            lineAnimation.duration = 0.5
            lineAnimation.fromValue = 0
            lineAnimation.toValue = 1
            
            var penAnimation = CAKeyframeAnimation(keyPath: "position")
            penAnimation.duration = lineAnimation.duration
            penAnimation.fillMode = kCAFillModeBoth
            penAnimation.calculationMode = kCAAnimationCubicPaced
            penAnimation.path = lineShapeLayer.path

        
            CATransaction.begin()
            
            CATransaction.setCompletionBlock{
                pencilLayer.removeFromSuperlayer()
                count = count + 1
                if count < self.arrayOfLines.count {
                    self.drawLinesAnimation(count)
                }
            }
            
            lineShapeLayer.addAnimation(lineAnimation, forKey: "strokeEnd")
            pencilLayer.addAnimation(penAnimation, forKey: "position")
            
            CATransaction.commit()
    }
    
    
}

