//
//  ViewController.swift
//  Calculator
//
//  Created by Clarissa Vazquez on 9/9/16.
//  Copyright © 2016 Clarissa Vazquez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    var brain = CalculatorBrain()
    var userIsInTheMiddleOfTypingANumber: Bool = false
    let decimalSeparator = NSNumberFormatter().decimalSeparator!
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        set {
            if (newValue != nil) {
                let numberFormatter = NSNumberFormatter()
                numberFormatter.numberStyle = .DecimalStyle
                numberFormatter.maximumFractionDigits = 10
                display.text = numberFormatter.stringFromNumber(newValue!)
            } else {
                display.text = "0"
            }
            userIsInTheMiddleOfTypingANumber = false
            let operandStack = brain.showStack()
            if !operandStack!.isEmpty {
                history.text = operandStack!.componentsSeparatedByString(".").joinWithSeparator(decimalSeparator) + " ="
            }
        }
    }

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            if (digit == decimalSeparator) && (display.text!.rangeOfString(decimalSeparator) != nil) { return }
            if (digit == "0") && ((display.text == "0") || (display.text == "-0")) { return }
            if (digit != decimalSeparator) && ((display.text == "0") || (display.text == "-0")) {
                if (display.text == "0") {
                    display.text = digit
                } else {
                    display.text = "-" + digit
                }
            } else {
                display.text = display.text! + digit
            }
        } else {
            if digit == decimalSeparator {
                display.text = "0" + decimalSeparator
            } else {
                display.text = digit
            }
            userIsInTheMiddleOfTypingANumber = true
            history.text = brain.showStack()
        }
    }
    
    
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if displayValue != nil {
            if let result = brain.pushOperand(displayValue!) {
                displayValue = result
            } else {
                displayValue = nil
            }
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if let operation = sender.currentTitle {
            if userIsInTheMiddleOfTypingANumber {
                enter()
            }
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = nil
            }
        }
    }
    
    @IBAction func clear(sender: UIButton) {
        history.text = ""
        brain.clearStack()
        display.text = "0"
    }
    
    
}

