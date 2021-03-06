//
//  CalculatorError.swift
//  CountOnMe
//
//  Created by Canessane Poudja on 21/04/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

enum CalculatorError: Error {
    case expressionIsIncorrect
    case expressionIsIncomplete
    case cannotAssignValue
    case equalSignFound
    case unknownOperatorFound

    var alertTitle: String {
        switch self {
        case .expressionIsIncorrect: return "Incorrect"
        case .expressionIsIncomplete: return "Incomplete"
        case .cannotAssignValue: return "Cannot assign value"
        case .equalSignFound: return "Equal sign found"
        case .unknownOperatorFound: return "Unknown operator"
        }
    }
    var alertMessage: String {
        switch self {
        case .expressionIsIncorrect: return "The expression is not correct !\nPlease enter a number after the operator."
        case .expressionIsIncomplete: return "The expression is not complete ! Please enter a number or an operator."
        case .cannotAssignValue: return "We cannot split the expression in 3 parts !"
        case .equalSignFound: return "There is already a result ! Please start a new operation."
        case .unknownOperatorFound: return "You have entered an unknown operator !"
        }
    }

}
