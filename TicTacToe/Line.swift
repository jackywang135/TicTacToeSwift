//
//  Line.swift
//  TicTacToe
//
//  Created by Jacky Wang on 10/29/14.
//  Copyright (c) 2014 JACKYWANG. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit

class Line {
    
    var point1 : CGPoint!
    var point2 : CGPoint!
    
    init(point1:CGPoint, point2:CGPoint) {
        self.point1 = point1
        self.point2 = point2
    }
    
    func getCGPath()-> CGPath {
        let bezierPath = UIBezierPath ()
        bezierPath.moveToPoint(point1)
        bezierPath.addLineToPoint(point2)
        
        return bezierPath.CGPath
    }
}