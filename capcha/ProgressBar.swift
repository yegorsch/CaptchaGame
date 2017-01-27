//
//  ProgressBar.swift
//  capcha
//
//  Created by Егор on 1/25/17.
//  Copyright © 2017 Yegor's Mac. All rights reserved.
//

import UIKit
class ProgressBar: UIView {
    
    @IBInspectable
    var progress:CGFloat = 1 { didSet { setNeedsDisplay() }} // Progress varies between 0 and 1
    @IBInspectable
    var color = UIColor.green { didSet { setNeedsDisplay() }}
    private var leftTop:CGPoint
    private var leftDown:CGPoint
    
    
    override init(frame: CGRect) {
        self.leftDown = CGPoint()
        self.leftTop = CGPoint()
        super.init(frame: frame)
        self.leftTop = CGPoint(x: bounds.minX, y: bounds.minY)
        self.leftDown = CGPoint(x: bounds.minX, y: bounds.maxY)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.leftDown = CGPoint()
        self.leftTop = CGPoint()
        super.init(coder: aDecoder)
        self.leftTop = CGPoint(x: bounds.minX, y: bounds.minY)
        self.leftDown = CGPoint(x: bounds.minX, y: bounds.maxY)
    }
    
    
    override func draw( _ rect: CGRect)
    {
        switch progress {
        case 0.8..<1:
            color = .green
        case 0.6..<0.8:
            color = .yellow
        case 0.4..<0.8:
            color = .orange
        case 0.1..<0.4:
            color = .red
        default:
            color = .green
        }
        color.set()
        pathForBar().fill()
        pathForBar().stroke()
    }
    
    private func pathForBar() -> UIBezierPath {
        let rightTop = CGPoint(x: bounds.maxX * progress , y: bounds.minY)
        let rightDown = CGPoint(x: bounds.maxX * progress , y: bounds.maxY)
        let path = UIBezierPath()
        path.move(to: leftTop)
        path.addLine(to: rightTop)
        path.addLine(to: rightDown)
        path.addLine(to: leftDown)
        path.close()
        return path
    }
    
}
