//courtsey: https://medium.com/@mihail_salari/3-20-observer-pattern-in-ios-the-neighborhood-gossip-chain-4a2e0c98463f

import UIKit

// In Observer pattern , when an object (subject) changes its state, all registered observers are automatically notified.

protocol GossipListener: class {
    func gossipDidChange(latestGossip: String)
}

class TownCrier {
    private var listeners: [GossipListener] = []
    var latestGossip: String = "" {
        didSet {
            notifyListeners()
        }
    }
    func addListener(_ listener: GossipListener) {
        listeners.append(listener)
    }
    private func notifyListeners() {
        for listener in listeners {
            listener.gossipDidChange(latestGossip: latestGossip)
        }
    }
}
class NosyNeighbor: GossipListener {
    func gossipDidChange(latestGossip: String) {
        print("Did you hear? \(latestGossip)")
    }
}
let townCrier = TownCrier()
let missPenny = NosyNeighbor()
townCrier.addListener(missPenny)
townCrier.latestGossip = "Mr. Smith got a new hat!"
// output : Did you hear? Mr. Smith got a new hat!

/*
 Pros:

     In the Loop: Everyone is updated in real-time.
     Decoupling: The town crier doesn’t need to know every neighbor personally; he just shouts!

 Cons:

     Too Much Noise: Too many notifications can lead to a lot of chatter.
     Memory Leaks: Nosy neighbors might forget to stop listening, leading to wasted resources.
 */

// https://refactoring.guru/design-patterns/observer/swift/example
import XCTest

protocol CartSubscriber: CustomStringConvertible {

    func accept(changed cart: [Product])
}

protocol Product {

    var id: Int { get }
    var name: String { get }
    var price: Double { get }

    func isEqual(to product: Product) -> Bool
}

extension Product {

    func isEqual(to product: Product) -> Bool {
        return id == product.id
    }
}

struct Food: Product {

    var id: Int
    var name: String
    var price: Double

    /// Food-specific properties
    var calories: Int
}

struct Clothes: Product {

    var id: Int
    var name: String
    var price: Double

    /// Clothes-specific properties
    var size: String
}

class CartManager {

    private lazy var cart = [Product]()
    private lazy var subscribers = [CartSubscriber]()

    func add(subscriber: CartSubscriber) {
        print("CartManager: I'am adding a new subscriber: \(subscriber.description)")
        subscribers.append(subscriber)
    }

    func add(product: Product) {
        print("\nCartManager: I'am adding a new product: \(product.name)")
        cart.append(product)
        notifySubscribers()
    }

    func remove(subscriber filter: (CartSubscriber) -> (Bool)) {
        guard let index = subscribers.firstIndex(where: filter) else { return }
        subscribers.remove(at: index)
    }

    func remove(product: Product) {
        guard let index = cart.firstIndex(where: { $0.isEqual(to: product) }) else { return }
        print("\nCartManager: Product '\(product.name)' is removed from a cart")
        cart.remove(at: index)
        notifySubscribers()
    }

    private func notifySubscribers() {
        subscribers.forEach({ $0.accept(changed: cart) })
    }
}

extension UINavigationBar: CartSubscriber {

    func accept(changed cart: [Product]) {
        print("UINavigationBar: Updating an appearance of navigation items")
    }

    open override var description: String { return "UINavigationBar" }
}

class CartViewController: UIViewController, CartSubscriber {

    func accept(changed cart: [Product]) {
        print("CartViewController: Updating an appearance of a list view with products")
    }

    open override var description: String { return "CartViewController" }
}

class ObserverRealWorld: XCTestCase {

    func test() {

        let cartManager = CartManager()

        let navigationBar = UINavigationBar()
        let cartVC = CartViewController()

        cartManager.add(subscriber: navigationBar)
        cartManager.add(subscriber: cartVC)

        let apple = Food(id: 111, name: "Apple", price: 10, calories: 20)
        cartManager.add(product: apple)

        let tShirt = Clothes(id: 222, name: "T-shirt", price: 200, size: "L")
        cartManager.add(product: tShirt)

        cartManager.remove(product: apple)
    }
}
