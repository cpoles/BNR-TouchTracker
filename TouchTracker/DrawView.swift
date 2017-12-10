//
//  DrawView.swift
//  TouchTracker
//
//  Created by Carlos Poles on 8/12/17.
//  Copyright © 2017 Carlos Poles. All rights reserved.
//

import UIKit

class DrawView: UIView {
    
    // MARK: - Properties
    var currentLines = [NSValue:Line]()
    var finishedLines =  [Line]()
    
    @IBInspectable var finishedLineColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var currentLineColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineThickness: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }

    // MARK: - Class Methods
    func stroke(_ line: Line) {
        let path = UIBezierPath()
        path.lineWidth = lineThickness
        path.lineCapStyle = .round
        
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Draw finished lines in black
        finishedLineColor.setStroke()
        for line in finishedLines {
            stroke(line)
        }
        
       // Draw current lines in red
        currentLineColor.setStroke()
        for (_ , line) in currentLines {
            stroke(line)
        }
    }
    
    // MARK: - Touches and Gestures
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Log statement to see the order of events
        print(#function)
        
        for touch in touches {
            // Get location of the touch on the view
            let location = touch.location(in: self)
            // create a line on that location
            let newLine = Line(begin: location, end: location)
            // Create a key for the currentLines dictionary based on the UITouch event
            let key = NSValue(nonretainedObject: touch)
            // Add new line to the dictionary
            currentLines[key] = newLine
        }
        // Refresh the view. Calls draw(_:)
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Log statement to see the order of events
        print(#function)
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            currentLines[key]?.end = touch.location(in: self)
        }
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Log statement to see the order of events
        print(#function)
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            if var line = currentLines[key] {
                line.end = touch.location(in: self)
                finishedLines.append(line)
                currentLines.removeValue(forKey: key)
            }
        }
        setNeedsDisplay() 
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Log statement to see the order of events
        print(#function)
        
        currentLines.removeAll()
        setNeedsDisplay()
    }
}
