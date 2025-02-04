//https://medium.com/@mihail_salari/10-20-the-chain-of-responsibility-pattern-passing-the-magical-torch-in-swift-fbf6121c82aa
import UIKit

// In  Chain of Responsibility pattern, objects are linked, passing requests along until one of them handles it.

protocol MagicalItem {
    var nextInChain: MagicalItem? { get set }
    func enchant(request: String) -> String?
}

class FireStaff: MagicalItem {
    var nextInChain: MagicalItem?
    func enchant(request: String) -> String? {
        if request == "Fireball" {
            return "Casting Fireball! 🔥"
        }
        return nextInChain?.enchant(request: request)
    }
}

class IceAmulet: MagicalItem {
    var nextInChain: MagicalItem?
    func enchant(request: String) -> String? {
        if request == "Freeze" {
            return "Casting Freeze! ❄️"
        }
        return nextInChain?.enchant(request: request)
    }
}

let staff = FireStaff()
let amulet = IceAmulet()

staff.nextInChain = amulet

print(staff.enchant(request: "Fireball")!) // "Casting Fireball! 🔥"
print(staff.enchant(request: "Freeze")!)   // "Casting Freeze! ❄️"

/*
 Advantages:
 Decouples senders from receivers: You don’t need to know which magical item handles the request.
 Dynamic chaining: Alter the chain’s order or introduce new items without changing the existing code.
 Streamlined magic handling: Each item is only concerned with its enchantment, keeping code clean and focused.
 */


// https://refactoring.guru/design-patterns/chain-of-responsibility
/// Chain of Responsibility is a behavioral design pattern that lets you pass requests along a chain of handlers. Upon receiving a request, each handler decides either to process the request or to pass it to the next handler in the chain.
///

import XCTest

/// The Handler interface declares a method for building the chain of handlers.
/// It also declares a method for executing a request.
protocol Handler: class {

    @discardableResult
    func setNext(handler: Handler) -> Handler

    func handle(request: String) -> String?

    var nextHandler: Handler? { get set }
}

extension Handler {

    func setNext(handler: Handler) -> Handler {
        self.nextHandler = handler

        /// Returning a handler from here will let us link handlers in a
        /// convenient way like this:
        /// monkey.setNext(handler: squirrel).setNext(handler: dog)
        return handler
    }

    func handle(request: String) -> String? {
        return nextHandler?.handle(request: request)
    }
}

/// All Concrete Handlers either handle a request or pass it to the next handler
/// in the chain.
class MonkeyHandler: Handler {

    var nextHandler: Handler?

    func handle(request: String) -> String? {
        if (request == "Banana") {
            return "Monkey: I'll eat the " + request + ".\n"
        } else {
            return nextHandler?.handle(request: request)
        }
    }
}

class SquirrelHandler: Handler {

    var nextHandler: Handler?

    func handle(request: String) -> String? {

        if (request == "Nut") {
            return "Squirrel: I'll eat the " + request + ".\n"
        } else {
            return nextHandler?.handle(request: request)
        }
    }
}

class DogHandler: Handler {

    var nextHandler: Handler?

    func handle(request: String) -> String? {
        if (request == "MeatBall") {
            return "Dog: I'll eat the " + request + ".\n"
        } else {
            return nextHandler?.handle(request: request)
        }
    }
}

/// The client code is usually suited to work with a single handler. In most
/// cases, it is not even aware that the handler is part of a chain.
class Client {
    // ...
    static func someClientCode(handler: Handler) {

        let food = ["Nut", "Banana", "Cup of coffee"]

        for item in food {

            print("Client: Who wants a " + item + "?\n")

            guard let result = handler.handle(request: item) else {
                print("  " + item + " was left untouched.\n")
                return
            }

            print("  " + result)
        }
    }
    // ...
}

/// Let's see how it all works together.
class ChainOfResponsibilityConceptual: XCTestCase {
 
    func test() {

        /// The other part of the client code constructs the actual chain.

        let monkey = MonkeyHandler()
        let squirrel = SquirrelHandler()
        let dog = DogHandler()
        monkey.setNext(handler: squirrel).setNext(handler: dog)

        /// The client should be able to send a request to any handler, not just
        /// the first one in the chain.

        print("Chain: Monkey > Squirrel > Dog\n\n")
        Client.someClientCode(handler: monkey)
        print()
        print("Subchain: Squirrel > Dog\n\n")
        Client.someClientCode(handler: squirrel)
    }
}
