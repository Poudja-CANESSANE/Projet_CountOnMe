# CountOnMe
This project is the fifth of the iOS Developer path from OpenClassrooms.  
I had to improve an existing app called CountOnMe, a basic calculator, by implementing the multiplication and the division.  
Consequently I also had to handle them according to order of operations.

This app is:

- responsive in all iPhones in portrait mode,
- available from iOS 11,
- conform to MVC,
- covered by unit tests.

6 functionalities are supported.

## Add relative numbers

<img src="gif/P5RelativeNumbers.gif" alt="drawing" width="200">

## Add operators
You can add operators and replace them by another.

<img src="gif/P5Operators.gif" alt="drawing" width="200">

## Clear
You can clear a character or the whole expression.  
When there is already a result and you tap on the ⌫ button, the whole expression will be cleared.

<img src="gif/P5Clear.gif" alt="drawing" width="200">

## Cannot start with "×" or "÷"
You cannot start an expression with a wrong operator even when there is a result.

<img src="gif/P5WrongOperator.gif" alt="drawing" width="200">

## Cannot add unnecessary 0
That means you cannot add two following 0 at the start of the expression or after an operator.  
Moreover you cannot add a 0 after division sign.  
Thus division by 0 is impossible.

<img src="gif/P5UnnecessaryZero.gif" alt="drawing" width="200">

## Alert are presented when the expression is invalid
They are presented when:
- there is not enough elements in the expression (3 minimum),
- the expression ends with an operator
- you tap on the equal button while there is alredy a result.

<img src="gif/P5Alert.gif" alt="drawing" width="200">
