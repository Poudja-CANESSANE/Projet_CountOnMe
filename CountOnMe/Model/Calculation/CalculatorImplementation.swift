// swiftlint:disable vertical_whitespace
//  Calculator.swift
//  CountOnMe
//
//  Created by Canessane Poudja on 14/04/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

class CalculatorImplementation: Calculator {

    // MARK: - INTERNAL

    // MARK: Properties

    weak var delegate: CalculatorDelegate?



    // MARK: Methods

    ///Appends a number to textToCompute and reset it if needed
    func add(number: Int) {
        if shouldResetTextToCompute { textToCompute = "" }
        if number == 0 && isAddingUnnecessaryZero { return }
        textToCompute.append("\(number)")
    }

    ///Appends correctly a math operator to textToCompute if possible and reset it if needed
    func add(mathOperator: MathOperator) {
        if shouldResetTextToCompute { textToCompute = "" }
        if isStartingWithWrongOperator(mathOperator: mathOperator) { return }
        if textToCompute.isEmpty {
            textToCompute.append(mathOperator.symbol)
        } else if textToComputeHasRelativeSign || textToCompute == "0" {
            textToCompute = String(textToCompute.dropLast())
            textToCompute.append(mathOperator.symbol)
        } else if expressionIsCorrect {
            textToCompute.append(" \(mathOperator.symbol) ")
        } else {
            textToCompute = String(textToCompute.dropLast(3))
            textToCompute.append(" \(mathOperator.symbol) ")
        }
    }

    ///Appends the result to textToCompute if there are no errors otherwise it throws it
    func calculate() throws {
        try verifyExpression()

        //Create local copy of operations
        var operationsToReduce = elements
        // If the expression 1 + 2 = 3, left = 1, mathOperator = "+", right = 2, result = 3
        var left: Float = 0
        var mathOperator = ""
        var right: Float = 0
        var result: Float = 0

        // Iterate over operations while an mathOperator still here
        while operationsToReduce.count > 1 {
            let index = getOperatorIndex(from: operationsToReduce)
            try assignValueForEachPartOfExpression(
                from: operationsToReduce,
                with: index,
                lhs: &left,
                operator: &mathOperator,
                rhs: &right)
            result = try performCalculation(lhs: left, rhs: right, operator: mathOperator)
            replaceOperationByResult(in: &operationsToReduce, at: index, with: result)
        }
        let formattedResult = format(number: result)
        textToCompute.append(" = \(formattedResult)")
        shouldResetTextToCompute = true
    }

    ///Clears totally textToCompute if shouldResetTextToCompute is true otherwise it removes only its last character
    func deleteLastElement() {
        if shouldResetTextToCompute {
            deleteAllElements()
        } else {
            textToCompute = cleaner.clearLastElement(of: textToCompute)
        }
    }

    ///Clears totally textToCompute
    func deleteAllElements() {
        textToCompute = cleaner.clearAll()
    }



    // MARK: - PRIVATE

    // MARK: Properties

    private let cleaner: Cleaner = CleanerImplementation()

    ///If it is true textToCompute is reset
    private var shouldResetTextToCompute = false

    ///Contains the expression
    private var textToCompute = "" {
        didSet {
            resetShouldResetTextToComputeIfNeeded()
            delegate?.didUpdateTextToCompute(text: textToCompute)
        }
    }

    ///This array contains each element of the expression
    private var elements: [String] {
        textToCompute.split(separator: " ").map { "\($0)" }
    }

    ///Checks if the last element of the expression is a math operator
    private var expressionIsCorrect: Bool {
        for mathOperator in MathOperator.allCases where mathOperator.symbol == elements.last {
            return false
        }
        return true
    }

    ///Checks if there is at least 3 elements in the expression
    private var expressionHasEnoughElement: Bool {
        elements.count >= 3
    }

    ///Checks if we can add a 0 by controlling the last and the before last characters of textToCompute
    private var isAddingUnnecessaryZero: Bool {
        //To check the before last character of textToCompute
        var text = textToCompute
        text = String(text.dropLast())

        return textToCompute == "0"
            || (text.last == " " && textToCompute.last == "0")
            || text.last == Character(MathOperator.divide.symbol)
            || ((text.last == Character(MathOperator.plus.symbol)
                || text.last == Character(MathOperator.minus.symbol))
                && textToCompute.last == "0")
    }

    ///Checks if there is only a plus or minus sign in textToCompute
    private var textToComputeHasRelativeSign: Bool {
        textToCompute == MathOperator.plus.symbol || textToCompute == MathOperator.minus.symbol
    }



    // MARK: Methods

    ///Returns true if the user is attempting to begin an expression with a multiply or division sign
    private func isStartingWithWrongOperator(mathOperator: MathOperator) -> Bool {
        return textToCompute.isEmpty && (mathOperator == MathOperator.multiply || mathOperator == MathOperator.divide)
    }

    ///Sets shouldResetTextToCompute to false if it is true
    private func resetShouldResetTextToComputeIfNeeded() {
        if shouldResetTextToCompute {
            shouldResetTextToCompute = false
        }
    }

    ///Throws an error if the expression is invalid
    private func verifyExpression() throws {
        guard expressionIsCorrect else { throw CalculatorError.expressionIsIncorrect }
        guard expressionHasEnoughElement else { throw CalculatorError.expressionIsIncomplete }
    }

    ///Returns the index of the first division or multiply sign if possible otherwise it returns 1
    private func getOperatorIndex(from array: [String]) -> Int {
        var index = 1
        if let divideIndex = array.firstIndex(of: MathOperator.divide.symbol) {
            index = divideIndex
            return index
        } else if let multiplyIndex = array.firstIndex(of: MathOperator.multiply.symbol) {
            index = multiplyIndex
            return index
        }
        return index
    }

    ///Tries to assigns to left, mathOperator and right an element of the expression otherwise it throws an error
    private func assignValueForEachPartOfExpression(
        from array: [String],
        with index: Int,
        lhs left: inout Float,
        operator mathOperator: inout String,
        rhs right: inout Float) throws {
        guard
            let lhs = Float(array[index - 1]),
            let rhs = Float(array[index + 1])
            else { throw CalculatorError.cannotAssignValue }

        left = lhs
        mathOperator = array[index]
        right = rhs
    }

    ///Tries to calculate result with right and left according to mathOperator otherwise it throws an error
    private func performCalculation(lhs: Float, rhs: Float, operator mathOperator: String) throws -> Float {
        switch mathOperator {
        case MathOperator.plus.symbol: return lhs + rhs
        case MathOperator.minus.symbol: return lhs - rhs
        case MathOperator.multiply.symbol: return lhs * rhs
        case MathOperator.divide.symbol: return lhs / rhs
        case "=": throw CalculatorError.equalSignFound
        default: throw CalculatorError.unknownOperatorFound
        }
    }

    ///Replace the operation which has just been carried out by its result in the given array
    private func replaceOperationByResult(in array: inout [String], at index: Int, with result: Float) {
        for _ in 1...3 { array.remove(at: index - 1) }
        array.insert("\(result)", at: index - 1)
    }

    ///Returns the given Float without .0 if it is a natural number
    private func format(number: Float) -> String {
        NumberFormatter.localizedString(from: NSNumber(value: number), number: .decimal)
    }
}
