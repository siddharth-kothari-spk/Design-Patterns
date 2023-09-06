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
