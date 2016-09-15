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
    var userIsInTheMiddleOfTypingANumber: Bool = false
    var operandStack = Array<Double>()
    var displayValue: Double {
        get {
            if(display.text! != "π") {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
            }
            else {
                return M_PI
            }
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    func appendHistory(str: String) {
        history.text = history.text! + str + " "
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        let str:String = String(format:"%.2f", displayValue)
        appendHistory(str)
        print("operandStack: \(operandStack)")
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        appendHistory(operation)
        switch operation {
        case "×": performOperation { $0 * $1 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $0 + $1 }
        case "−": performOperation { $1 - $0 }
        case "√": performOperation { sqrt($0) }
        case "cos": performOperation { cos($0) }
        case "sin": performOperation { sin($0) }
        default:
            break
        }
    }
    
    @IBAction func clear(sender: UIButton) {
        history.text = ""
        operandStack.removeAll()
        display.text = "0"
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if(operandStack.count >= 2) {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    private func performOperation(operation: Double -> Double) {
        if(operandStack.count >= 1) {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
}

