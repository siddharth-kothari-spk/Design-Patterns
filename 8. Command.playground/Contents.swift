// https://medium.com/@mihail_salari/8-20-the-command-pattern-making-orders-like-a-pro-chef-3a668a30481f
import UIKit
// Command Pattern turns a request into a stand-alone object containing info about the request.

protocol OrderCommand {
    func execute() -> String
}

class BurgerOrder: OrderCommand {
    func execute() -> String {
        return "Burger is being prepared!"
    }
}

class PizzaOrder: OrderCommand {
    func execute() -> String {
        return "Pizza coming right up!"
    }
}

class Chef {
    func takeOrder(order: OrderCommand) {
        print(order.execute())
    }
}

let chef = Chef()
let burger = BurgerOrder()
let pizza = PizzaOrder()

chef.takeOrder(order: burger)  // Prints "Burger is being prepared!"

chef.takeOrder(order: pizza)  // Prints "Pizza coming right up!"


