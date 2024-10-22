// courtsey: https://medium.com/@mihail_salari/4-20-unwrapping-the-builder-design-pattern-lets-construct-some-fun-%EF%B8%8F-ecf9dc72ef7d

import UIKit

//Builder pattern allows a step-by-step creation of complex objects using the correct sequence of actions.

protocol PizzaBuilder {
    func setDough(_ dough: String)
    func setSauce(_ sauce: String)
    func addTopping(_ topping: String)
    func build() -> Pizza
}

// Concrete Builder
class MargheritaPizzaBuilder: PizzaBuilder {
    private var dough: String = ""
    private var sauce: String = ""
    private var toppings: [String] = []
    
    func setDough(_ dough: String) { self.dough = dough }
    func setSauce(_ sauce: String) { self.sauce = sauce }
    func addTopping(_ topping: String) { toppings.append(topping) }
    
    func build() -> Pizza {
        return Pizza(dough: dough, sauce: sauce, toppings: toppings)
    }
}

// Product
struct Pizza {
    let dough: String
    let sauce: String
    let toppings: [String]
}

// Director
class Pizzeria {
    func constructPizza(using builder: PizzaBuilder) -> Pizza {
        builder.setDough("Thin Crust")
        builder.setSauce("Tomato")
        builder.addTopping("Mozzarella")
        builder.addTopping("Basil")
        return builder.build()
    }
}


// Let's make a pizza!
let pizzeria = Pizzeria()
let margherita = pizzeria.constructPizza(using: MargheritaPizzaBuilder())
print("Yum! You've built a \(margherita.toppings.joined(separator: ", ")) Pizza!")

// https://refactoring.guru/design-patterns/builder/swift/example
// Builder is a creational design pattern, which allows constructing complex objects step by step.

import Foundation
import XCTest


class BaseQueryBuilder<Model: DomainModel> {

    typealias Predicate = (Model) -> (Bool)

    func limit(_ limit: Int) -> BaseQueryBuilder<Model> {
        return self
    }

    func filter(_ predicate: @escaping Predicate) -> BaseQueryBuilder<Model> {
        return self
    }

    func fetch() -> [Model] {
        /// Use this function to stop the program when control flow can only reach the
        /// call if your API was improperly used and execution flow is not expected to
        /// reach the call---for example, in the `default` case of a `switch` where
        /// you have knowledge that one of the other cases must be satisfied.
        preconditionFailure("Should be overridden in subclasses.")
    }
}

class RealmQueryBuilder<Model: DomainModel>: BaseQueryBuilder<Model> {

    enum Query {
        case filter(Predicate)
        case limit(Int)
        /// ...
    }

    fileprivate var operations = [Query]()

    @discardableResult
    override func limit(_ limit: Int) -> RealmQueryBuilder<Model> {
        operations.append(Query.limit(limit))
        return self
    }

    @discardableResult
    override func filter(_ predicate: @escaping Predicate) -> RealmQueryBuilder<Model> {
        operations.append(Query.filter(predicate))
        return self
    }

    override func fetch() -> [Model] {
        print("RealmQueryBuilder: Initializing RealmDataProvider with \(operations.count) operations:")
        return RealmProvider().fetch(operations)
    }
}

class CoreDataQueryBuilder<Model: DomainModel>: BaseQueryBuilder<Model> {

    enum Query {
        case filter(Predicate)
        case limit(Int)
        case includesPropertyValues(Bool)
        /// ...
    }

    fileprivate var operations = [Query]()

    override func limit(_ limit: Int) -> CoreDataQueryBuilder<Model> {
        operations.append(Query.limit(limit))
        return self
    }

    override func filter(_ predicate: @escaping Predicate) -> CoreDataQueryBuilder<Model> {
        operations.append(Query.filter(predicate))
        return self
    }

    func includesPropertyValues(_ toggle: Bool) -> CoreDataQueryBuilder<Model> {
        operations.append(Query.includesPropertyValues(toggle))
        return self
    }

    override func fetch() -> [Model] {
        print("CoreDataQueryBuilder: Initializing CoreDataProvider with \(operations.count) operations.")
        return CoreDataProvider().fetch(operations)
    }
}


/// Data Providers contain a logic how to fetch models. Builders accumulate
/// operations and then update providers to fetch the data.

class RealmProvider {

    func fetch<Model: DomainModel>(_ operations: [RealmQueryBuilder<Model>.Query]) -> [Model] {

        print("RealmProvider: Retrieving data from Realm...")

        for item in operations {
            switch item {
            case .filter(_):
                print("RealmProvider: executing the 'filter' operation.")
                /// Use Realm instance to filter results.
                break
            case .limit(_):
                print("RealmProvider: executing the 'limit' operation.")
                /// Use Realm instance to limit results.
                break
            }
        }

        /// Return results from Realm
        return []
    }
}

class CoreDataProvider {

    func fetch<Model: DomainModel>(_ operations: [CoreDataQueryBuilder<Model>.Query]) -> [Model] {

        /// Create a NSFetchRequest

        print("CoreDataProvider: Retrieving data from CoreData...")

        for item in operations {
            switch item {
            case .filter(_):
                print("CoreDataProvider: executing the 'filter' operation.")
                /// Set a 'predicate' for a NSFetchRequest.
                break
            case .limit(_):
                print("CoreDataProvider: executing the 'limit' operation.")
                /// Set a 'fetchLimit' for a NSFetchRequest.
                break
            case .includesPropertyValues(_):
                print("CoreDataProvider: executing the 'includesPropertyValues' operation.")
                /// Set an 'includesPropertyValues' for a NSFetchRequest.
                break
            }
        }

        /// Execute a NSFetchRequest and return results.
        return []
    }
}


protocol DomainModel {
    /// The protocol groups domain models to the common interface
}

private struct User: DomainModel {
    let id: Int
    let age: Int
    let email: String
}


class BuilderRealWorld: XCTestCase {

    func testBuilderRealWorld() {
        print("Client: Start fetching data from Realm")
        clientCode(builder: RealmQueryBuilder<User>())

        print()

        print("Client: Start fetching data from CoreData")
        clientCode(builder: CoreDataQueryBuilder<User>())
    }

    fileprivate func clientCode(builder: BaseQueryBuilder<User>) {

        let results = builder.filter({ $0.age < 20 })
            .limit(1)
            .fetch()

        print("Client: I have fetched: " + String(results.count) + " records.")
    }
}
