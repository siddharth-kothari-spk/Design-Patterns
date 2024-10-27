//https://medium.com/@mihail_salari/9-20-the-strategy-pattern-pick-your-gameplay-strategy-slay-1dd1f9693d85
import UIKit

//The Strategy Pattern allows an algorithm’s implementation to be selected at runtime.

// Strategy Protocol
protocol BattleStrategy {
    func execute() -> String
}

class StealthAttack: BattleStrategy {
    func execute() -> String {
        return "Attacking with stealth! 🕶️"
    }
}

class DirectCombat: BattleStrategy {
    func execute() -> String {
        return "Engaging in direct combat! 🗡️"
    }
}

class GameCharacter {
    var strategy: BattleStrategy
    
    init(strategy: BattleStrategy) {
        self.strategy = strategy
    }
    
    func attack() -> String {
        return strategy.execute()
    }
}

let ninja = GameCharacter(strategy: StealthAttack())
print(ninja.attack()) // "Attacking with stealth! 🕶️"

let knight = GameCharacter(strategy: DirectCombat())
print(knight.attack()) // "Engaging in direct combat! 🗡️"

// https://refactoring.guru/design-patterns/strategy/swift/example#example-0
/// Strategy is a behavioral design pattern that turns a set of behaviors into objects and makes them interchangeable inside original context object.

///The original object, called context, holds a reference to a strategy object. The context delegates executing the behavior to the linked strategy object. In order to change the way the context performs its work, other objects may replace the currently linked strategy object with another one.

// sample 1
import XCTest

/// The Context defines the interface of interest to clients.
class Context {

    /// The Context maintains a reference to one of the Strategy objects. The
    /// Context does not know the concrete class of a strategy. It should work
    /// with all strategies via the Strategy interface.
    private var strategy: Strategy

    /// Usually, the Context accepts a strategy through the constructor, but
    /// also provides a setter to change it at runtime.
    init(strategy: Strategy) {
        self.strategy = strategy
    }

    /// Usually, the Context allows replacing a Strategy object at runtime.
    func update(strategy: Strategy) {
        self.strategy = strategy
    }

    /// The Context delegates some work to the Strategy object instead of
    /// implementing multiple versions of the algorithm on its own.
    func doSomeBusinessLogic() {
        print("Context: Sorting data using the strategy (not sure how it'll do it)\n")

        let result = strategy.doAlgorithm(["a", "b", "c", "d", "e"])
        print(result.joined(separator: ","))
    }
}

/// The Strategy interface declares operations common to all supported versions
/// of some algorithm.
///
/// The Context uses this interface to call the algorithm defined by Concrete
/// Strategies.
protocol Strategy {

    func doAlgorithm<T: Comparable>(_ data: [T]) -> [T]
}

/// Concrete Strategies implement the algorithm while following the base
/// Strategy interface. The interface makes them interchangeable in the Context.
class ConcreteStrategyA: Strategy {

    func doAlgorithm<T: Comparable>(_ data: [T]) -> [T] {
        return data.sorted()
    }
}

class ConcreteStrategyB: Strategy {

    func doAlgorithm<T: Comparable>(_ data: [T]) -> [T] {
        return data.sorted(by: >)
    }
}

/// Let's see how it all works together.
class StrategyConceptual: XCTestCase {

    func test() {

        /// The client code picks a concrete strategy and passes it to the
        /// context. The client should be aware of the differences between
        /// strategies in order to make the right choice.

        let context = Context(strategy: ConcreteStrategyA())
        print("Client: Strategy is set to normal sorting.\n")
        context.doSomeBusinessLogic()

        print("\nClient: Strategy is set to reverse sorting.\n")
        context.update(strategy: ConcreteStrategyB())
        context.doSomeBusinessLogic()
    }
}

// sample 2
import XCTest

class StrategyRealWorld: XCTestCase {

    /// This example shows a simple implementation of a list controller that is
    /// able to display models from different data sources:
    ///
    /// (MemoryStorage, CoreDataStorage, RealmStorage)

    func test() {

        let controller = ListController()

        let memoryStorage = MemoryStorage<User>()
        memoryStorage.add(usersFromNetwork())

        clientCode(use: controller, with: memoryStorage)

        clientCode(use: controller, with: CoreDataStorage())

        clientCode(use: controller, with: RealmStorage())
    }

    func clientCode(use controller: ListController, with dataSource: DataSource) {

        controller.update(dataSource: dataSource)
        controller.displayModels()
    }

    private func usersFromNetwork() -> [User] {
        let firstUser = User(id: 1, username: "username1")
        let secondUser = User(id: 2, username: "username2")
        return [firstUser, secondUser]
    }
}

class ListController {

    private var dataSource: DataSource?

    func update(dataSource: DataSource) {
        /// ... resest current states ...
        self.dataSource = dataSource
    }

    func displayModels() {

        guard let dataSource = dataSource else { return }
        let models = dataSource.loadModels() as [User]

        /// Bind models to cells of a list view...
        print("\nListController: Displaying models...")
        models.forEach({ print($0) })
    }
}

protocol DataSource {

    func loadModels<T: DomainModel>() -> [T]
}

class MemoryStorage<Model>: DataSource {

    private lazy var items = [Model]()

    func add(_ items: [Model]) {
        self.items.append(contentsOf: items)
    }

    func loadModels<T: DomainModel>() -> [T] {
        guard T.self == User.self else { return [] }
        return items as! [T]
    }
}

class CoreDataStorage: DataSource {

    func loadModels<T: DomainModel>() -> [T] {
        guard T.self == User.self else { return [] }

        let firstUser = User(id: 3, username: "username3")
        let secondUser = User(id: 4, username: "username4")

        return [firstUser, secondUser] as! [T]
    }
}

class RealmStorage: DataSource {

    func loadModels<T: DomainModel>() -> [T] {
        guard T.self == User.self else { return [] }

        let firstUser = User(id: 5, username: "username5")
        let secondUser = User(id: 6, username: "username6")

        return [firstUser, secondUser] as! [T]
    }
}

protocol DomainModel {

    var id: Int { get }
}

struct User: DomainModel {

    var id: Int
    var username: String
}
