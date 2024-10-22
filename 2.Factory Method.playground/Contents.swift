//courtsey: https://medium.com/@mihail_salari/2-20-factory-method-in-ios-the-master-chef-of-object-creation-80e08747e5af

import UIKit
// The Factory Method pattern provides an interface for creating objects, but it’s the subclasses that decide which class to instantiate.


protocol Dish {
    func prepare()
}

class Pasta: Dish {
    func prepare() {
        print("Cooking Pasta with Marinara sauce!")
    }
}

class Sushi: Dish {
    func prepare() {
        print("Rolling up some fresh Tuna Sushi!")
    }
}

enum CuisineType {
    case italian, japanese
}

class DishFactory {
    static func makeDish(for cuisine: CuisineType) -> Dish {
        switch cuisine {
        case .italian:
            return Pasta()
        case .japanese:
            return Sushi()
        }
    }
}

let myDish = DishFactory.makeDish(for: .japanese)
myDish.prepare()  // Output: Rolling up some fresh Tuna Sushi!

/*
 Pros:

     Flexibility: Like a chef experimenting with ingredients, this pattern lets developers modify and add classes with ease.
     Consistency: The process of ordering remains the same, ensuring a unified interface.

 Cons:

     Complexity: Sometimes, there can be too many chefs in the kitchen, leading to unnecessary subclassing.
     Abstraction Overload: One might over-engineer the solution when a simple instantiation would suffice.
 */

//  https://refactoring.guru/design-patterns/factory-method/swift/example
//Factory method is a creational design pattern which solves the problem of creating product objects without specifying their concrete classes

import XCTest

class FactoryMethodRealWorld: XCTestCase {

    func testFactoryMethodRealWorld() {

        let info = "Very important info of the presentation"

        let clientCode = ClientCode()

        /// Present info over WiFi
        clientCode.present(info: info, with: WifiFactory())

        /// Present info over Bluetooth
        clientCode.present(info: info, with: BluetoothFactory())
    }
}

protocol ProjectorFactory {

    func createProjector() -> Projector

    func syncedProjector(with projector: Projector) -> Projector
}

extension ProjectorFactory {

    /// Base implementation of ProjectorFactory

    func syncedProjector(with projector: Projector) -> Projector {

        /// Every instance creates an own projector
        let newProjector = createProjector()

        /// sync projectors
        newProjector.sync(with: projector)

        return newProjector
    }
}

class WifiFactory: ProjectorFactory {

    func createProjector() -> Projector {
        return WifiProjector()
    }
}

class BluetoothFactory: ProjectorFactory {

    func createProjector() -> Projector {
        return BluetoothProjector()
    }
}

protocol Projector {

    /// Abstract projector interface

    var currentPage: Int { get }

    func present(info: String)

    func sync(with projector: Projector)

    func update(with page: Int)
}

extension Projector {

    /// Base implementation of Projector methods

    func sync(with projector: Projector) {
        projector.update(with: currentPage)
    }
}

class WifiProjector: Projector {

    var currentPage = 0

    func present(info: String) {
        print("Info is presented over Wifi: \(info)")
    }

    func update(with page: Int) {
        /// ... scroll page via WiFi connection
        /// ...
        currentPage = page
    }
}

class BluetoothProjector: Projector {

    var currentPage = 0

    func present(info: String) {
        print("Info is presented over Bluetooth: \(info)")
    }

    func update(with page: Int) {
        /// ... scroll page via Bluetooth connection
        /// ...
        currentPage = page
    }
}

private class ClientCode {

    private var currentProjector: Projector?

    func present(info: String, with factory: ProjectorFactory) {

        /// Check wheater a client code already present smth...

        guard let projector = currentProjector else {

            /// 'currentProjector' variable is nil. Create a new projector and
            /// start presentation.

            let projector = factory.createProjector()
            projector.present(info: info)
            self.currentProjector = projector
            return
        }

        /// Client code already has a projector. Let's sync pages of the old
        /// projector with a new one.

        self.currentProjector = factory.syncedProjector(with: projector)
        self.currentProjector?.present(info: info)
    }
}
