import Foundation

// *******************
// **** Optionals ****
// *******************

//func foo() -> Void {
//    return ()
//}
//
//() == ()
//
//func doSomething<T: Equatable>(_ t: T) {
//    print(t)
//}
//
//doSomething(())

// nil == (void *)0x0

enum MyOptional<Wrapped> {
    case none
    case some(Wrapped)
}

let x: Int? = .some(1)
let a: Optional<Int> = 1
let y: Int? = nil
let z: Int? = .none

let myOptional: MyOptional<Int> = nil

extension MyOptional: ExpressibleByNilLiteral {
    init(nilLiteral: ()) {
        self = .none
    }
}

switch x {
case .none:
    print("x was nil")
case .some(let wrapped):
    print("x was \(wrapped)")
}

switch x {
case nil:
    print("x was nil")
case .some(let wrapped):
    print("x was \(wrapped)")
}

let veryVeryOptional: Int???
let veryVeryOptionalMoreClear: Optional<Optional<Optional<Int>>>

enum FavoriteColor {
    case red
    case green
    case blue
}

//let favoriteColor: FavoriteColor??
let hasNotPickedYet: FavoriteColor?? = nil // .none
let hasPicked: FavoriteColor?? = .blue // .some(.some(.blue))
let hasPickedNone: FavoriteColor?? = .some(nil) // .some(.none)

import SwiftUI

// Optional.some is different from some View
struct MyView: View {
    var body: some View {
        EmptyView()
    }
}

type(of: Int?????????.some(1))

let result: FavoriteColor? = .red

func processResult(_ result: FavoriteColor) {
    print("result is \(result)")
}

let someBackupResult: FavoriteColor? = .green

processResult(result ?? someBackupResult ?? .blue)
processResult(result!)

postfix operator <<!

extension MyOptional {
    static postfix func <<!(value: Self) -> Wrapped {
        switch value {
        case .none:
            fatalError("Unexpectedly found nil while unwrapping…")
        case let .some(value):
            return value
        }
    }
}

MyOptional.some(1)<<!
//MyOptional<Int>.none<<!

extension MyOptional {
    static func ??(lhs: Self, rhs: @autoclosure () -> Error) throws -> Wrapped {
        switch lhs {
        case let .some(wrapped):
            return wrapped
        case .none:
            throw rhs()
        }
    }
}

struct MyError: Error {
    init() {
        print("making error")
    }
}
try MyOptional.some(1) ?? MyError()
do {
    try MyOptional<Int>.none ?? MyError()
} catch {
    print(error)
}

if let result = result,
   let other = Optional<Int>(1),
   let other2 = Optional<Int>(2) {
    processResult(result)
    _ = other
    _ = other2
} else {

}

enum ValueBox {
    case int(Int)
    case string(String)
    case bool(Bool)
}

let someValue = ValueBox.string("hi")

switch someValue {
case .string(let string):
    print(string)
case .bool:
    break
case .int:
    break
}

if case .string(let string) = someValue {
    print(string)
}

let things: [ValueBox] = [.bool(true), .string("hi"), .int(1)]
for thing in things {
    if case .bool(let bool) = thing {
        print(bool)
    }
}

for case .bool(let bool) in things where bool == true {
    print(bool)
}

var thing: ValueBox = .int(1)

while case .int(let value) = thing {
    print("thing:", thing)
    if value < 5 {
        thing = .int(value + 1)
    }
    else {
        thing = .string("all done")
    }
}
print(thing)

var mutableArray: [Int] = [0, 1, 2, 3, 4, 5]
var index = 0
//while index < mutableArray.endIndex {
//    mutableArray.remove(at: 0)
//}
for _ in mutableArray {
    if index == 2 {
        mutableArray.remove(at: index)
    }
    index += 1
}
print(mutableArray)

func needAFunctionToWrapAGuard() {
    guard let result = result else {
        return
    }
    print(result)
}


// *****************
// **** Closure ****
// *****************

func isIntSameAsStringFunc(int: Int, string: String) -> Bool {
    String(int) == string
}

let isIntSameAsStringClosure: (Int, String) -> Bool = { int, string in
    String(int) == string
}

let isIntSameAsStringClosure2 = { (int: Int, string: String) -> Bool in
    String(int) == string
}

let isIntSameAsStringClosure3: (Int, String) -> Bool = { String($0) == $1 }

let ints = [1, 2, 3, 4, 5]
var stringified: [String] = []
for int in ints {
    stringified.append(String(int))
}
stringified

ints
    .map { int in String(int) }

ints
    .map { String($0) }

ints
    .map { String.init($0) }

ints
    .map(String.init(_:))

let intToString: (Int) -> String = String.init(_:)

ints
    .map(intToString)

struct IntToStringConverter {
    func callAsFunction(_ int: Int) -> String {
        String(int)
    }
}

let converter = IntToStringConverter()
converter(5)

extension MyOptional {
    func map<NewType>(transform: (Wrapped) -> NewType) -> MyOptional<NewType> {
        switch self {
        case MyOptional<Wrapped>.none:
            return .none
        case .some(let wrappedValue):
            let transformed = transform(wrappedValue)
            return .some(transformed)
        }
    }
}


let optionalInt = MyOptional<Int>.some(4)

let squaredString = optionalInt.map(transform: { (int: Int) in
    String(int * int)
})

let shorthandVersion = optionalInt.map(transform: String.init)

print(optionalInt)

optionalInt.map { realInt in
    print(realInt)
}

let optionalStringThatIsANumber = Optional<String>.some("123")
let optionalStringThatIsNaN = Optional<String>.some("hello")

let convertedToInt = optionalStringThatIsANumber
    .map { (string) -> Int? in
        let converted = Int(string)
        return converted
    }

extension MyOptional {
    func flatMap<NewType>(transform: (Wrapped) -> NewType?) -> MyOptional<NewType> {
        switch self {
        case MyOptional<Wrapped>.none:
            return .none
        case .some(let wrappedValue):
            if let transformed = transform(wrappedValue) {
                return .some(transformed)
            } else {
                return .none
            }
        }
    }
}

let convertedToIntFlatly = optionalStringThatIsANumber
    .flatMap { (string) -> Int? in
        let converted = Int(string)
        return converted
    }
type(of: convertedToIntFlatly)
type(of: convertedToInt)

let nestedArray = [[1, 2], [3, 4, 5]]
let flattenedArray = nestedArray
    .flatMap { $0 }
let arrayOfOptionals: [Int?] = [1, 2, nil, 4, nil]
let flattenedOptionals = arrayOfOptionals
    .compactMap { $0 }
