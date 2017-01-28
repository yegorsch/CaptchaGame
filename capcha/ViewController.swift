//
//  ViewController.swift
//  capcha
//
//  Created by Егор on 1/25/17.
//  Copyright © 2017 Yegor's Mac. All rights reserved.
//

import UIKit
import Foundation


class ViewController: UIViewController {
    
    @IBOutlet weak var progressBar: ProgressBar!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var box: UIView!
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var capchaLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var capcha = "" { didSet { capchaLabel.text = "\(capcha)"} }
    var score = 0 { didSet {scoreLabel.text = "\(score)"} }
    var timer = Timer()
    var seconds = levelConstants.time { didSet {progressBar.progress = progressBar.progress - 1/30} }
    var didPressStartButton = false
    
    private struct levelConstants{
        static let time  = 6.0
        static let punishment = 50
        static let prize =  50
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        capchaLabel.font = UIFont(name: "1942 report", size: 60)
        capchaLabel.textColor = UIColor.white
        getNewCapcha()
        
        // Do not use autocorrection
        inputField.autocorrectionType = .no
        
        box.layer.cornerRadius = box.frame.width/4
        
        
        startButton.addTarget(self, action: #selector(self.start), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
//        self.scrollView.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(dismissKeys)))
    }
    
    
    @IBAction func submit(_ sender: UIButton)
    {
        if inputField.text == capcha{
            // Varying the score based of how fast capcha was typed
            score = Int(CGFloat(levelConstants.prize) * (1 + progressBar.progress))
            print("equls")
        }else{
            score = score - levelConstants.punishment
            print("not")
        }
        progressBar.progress = 1.0
        seconds = levelConstants.time
        getNewCapcha()
        inputField.text = ""
    }
    
    
    func start(_ sender: UIButton) {
        // Here I want to change the button title from "start" to "pause"
        if !didPressStartButton{
            didPressStartButton = true
            startButton.setTitle("Pause", for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(counter), userInfo: nil, repeats: true)
        }else{
            didPressStartButton = false
            startButton.setTitle("Start", for: .normal)
            timer.invalidate()
        }
    }
    
    
    func counter(){
        seconds = seconds - 0.2
        // Here we have to calculate step for progress bar based on the time interval
        // Timer ran out actions
        if seconds < 0 {
            timer.invalidate()
            score = score  - levelConstants.punishment
            seconds = levelConstants.time
            inputField.text = ""
            progressBar.progress = 1
            progressBar.setNeedsDisplay()
            timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(counter), userInfo: nil, repeats: true)
            getNewCapcha()
        }
    }
    
    func getNewCapcha(){
        capcha = ""
        box.backgroundColor = getRandomColor()
        var sampleSpace = "abcdefghijklmnopqrstuvwxyz123456789"
        let sampleSpaceNum = sampleSpace.characters.count
        for _ in 1...5{
            let index = sampleSpace.characters.index(sampleSpace.startIndex, offsetBy: Int(arc4random_uniform(UInt32(sampleSpaceNum))))
            capcha.append(sampleSpace[index])
        }
    }
    
    
    func getRandomColor() -> UIColor{
        capcha = ""
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }

    // keyboard adjust
    func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + startButton.frame.size.height -
            (inputField.frame.maxY - startButton.frame.minY)
        self.scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }
    
//    func dismissKeys(){
//        self.scrollView.endEditing(true)
//        print("lol")
//    }
    

    
}

