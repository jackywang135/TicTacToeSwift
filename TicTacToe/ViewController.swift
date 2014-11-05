//
//  ViewController.swift
//  TicTacToe
//
//  Created by Jacky Wang on 10/28/14.
//  Copyright (c) 2014 JACKYWANG. All rights reserved.
//

import UIKit
import QuartzCore
import Foundation

enum Turn {
    case Xturn, Oturn
}

enum GameStatus {
    case win, tie, inconclusive
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

class ViewController: UIViewController, BlockViewDelegate {

    required init(coder aDecoder: NSCoder) {
        turn = .Xturn
        gameStatus = .inconclusive
        theWinningCombo = [Int]()
        super.init(coder: aDecoder)
        
    }
    
    var turn : Turn
    var gameStatus : GameStatus
    let winningBlockCombinations = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
    var theWinningCombo : [Int]
    
    @IBOutlet var blockViewCollection: Array <BlockView>!
    
    
    
    var arrayOfLines : [Line] {
        get {
            return setUpLines()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawLinesAnimation(0)
        
        for blockView in blockViewCollection {
            blockView.blockViewDelegate = self
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tap(sender: UITapGestureRecognizer) {
        
        if gameStatus == .inconclusive {
        
            let point = sender.locationInView(self.view)
            var blockView = self.view.hitTest(point, withEvent:nil)!
        
            if let blockView = blockView as? BlockView {
                if blockView.mark == .Empty {
                    blockView.drawMark(turn.getMark())
                    checkGameStatus()
                    if gameStatus == .inconclusive {
                        turn = turn.switchTurn()
                    }
                }
            }
        }
    }
    
    func checkGameStatus() {
        
        if checkIfWin() {
            gameStatus = .win
            return
            }
//        if checkIfTie() {
//            gameStatus = .tie
//            return
//            
//            
//            
//            
//        }
        gameStatus = .inconclusive
    }
    
    func newGame() {

    }
    
    func checkIfWin() -> Bool {
        for array in winningBlockCombinations {
            if blockViewCollection[array[0]].mark == blockViewCollection[array[1]].mark && blockViewCollection[array[1]].mark == blockViewCollection[array[2]].mark && blockViewCollection[array[0]].mark != .Empty {
                theWinningCombo = array
                return true
            }
        }
        return false
    }
    
    func checkIfTie() -> Bool {
        
        var emptyBlocks = [BlockView]()
        var unCheckedBlocks = [BlockView]()
        
        for blockView in blockViewCollection {
            if blockView.mark == .Empty {
                emptyBlocks.append(blockView)
                unCheckedBlocks.append(blockView)
            }
        }
        
        for (index1, blockView) in enumerate(unCheckedBlocks) {
            
            for (index2, blockView) in enumerate(emptyBlocks) {
                blockView.mark = turn.getMark()
                if checkIfWin() {
                    return false
                }
                turn.switchTurn()
                emptyBlocks.removeAtIndex(index2)
            }
            unCheckedBlocks.removeAtIndex(index1)
            
            unCheckedBlocks.removeLast()
            
        }
        return true
    }
    
    func didFinishDrawMarkAnimation() {
        
        if (gameStatus == .win){
            drawWinningLine()
        }
    }
    
    func drawWinningLine() {
        
        let winningPath = UIBezierPath ()
        
        let winningPoint1 : CGPoint = blockViewCollection[theWinningCombo[0]].center
        let winningPoint2 : CGPoint = blockViewCollection[theWinningCombo[2]].center
        
        let winningLine = Line(point1:winningPoint1, point2:winningPoint2)
        
        let winningLineShapeLayer = CAShapeLayer()
        winningLineShapeLayer.path = winningLine.getCGPath()
        winningLineShapeLayer.lineWidth = CGFloat(15)
        winningLineShapeLayer.strokeColor = UIColor.blackColor().CGColor
        self.view.layer.addSublayer(winningLineShapeLayer)
        
        let pencilImage = UIImage(named: "Pencil")
        var pencilLayer = CALayer()
        pencilLayer.contents = pencilImage!.CGImage
        pencilLayer.anchorPoint = CGPointMake(0, 0)
        pencilLayer.frame = CGRectMake(-600, -600, pencilImage!.size.width, pencilImage!.size.height)

        winningLineShapeLayer.addSublayer(pencilLayer)
        
        var winningLineAnimation = CABasicAnimation(keyPath: "strokeEnd")
        winningLineAnimation.duration = 0.5
        winningLineAnimation.fromValue = 0
        winningLineAnimation.toValue = 1
        
        var penAnimation = CAKeyframeAnimation(keyPath: "position")
        penAnimation.duration = winningLineAnimation.duration
        penAnimation.fillMode = kCAFillModeBoth
        penAnimation.calculationMode = kCAAnimationCubicPaced
        penAnimation.path = winningLineShapeLayer.path
        
        winningLineShapeLayer.addAnimation(winningLineAnimation, forKey: "strokeEnd")
        pencilLayer.addAnimation(penAnimation, forKey: "position")
        
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
    
    func eraseAnimation() {
        
    }
    
    func setUpLines() -> [Line] {
        let screenHeight = CGFloat(UIScreen.mainScreen().bounds.height)
        let screenWidth = CGFloat(UIScreen.mainScreen().bounds.width)
        
        let lineVerticalLeft = Line(point1: CGPointMake(screenWidth/3, 0), point2: CGPointMake(screenWidth/3, screenHeight))
        let lineVerticalRight = Line(point1: CGPointMake(screenWidth*2/3, 0), point2: CGPointMake(screenWidth*2/3, screenHeight))
        let lineHorizonatalTop = Line(point1: CGPointMake(0, screenHeight/3), point2: CGPointMake(screenWidth, screenHeight/3))
        let lineHorizontalBottom = Line(point1: CGPointMake(0, screenHeight*2/3), point2: CGPointMake(screenWidth, screenHeight*2/3))
        
        return [lineHorizonatalTop, lineHorizontalBottom, lineVerticalLeft, lineVerticalRight]
    }
    
    
}

