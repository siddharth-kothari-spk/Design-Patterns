// https://medium.com/@mihail_salari/7-20-the-decorator-pattern-accessorizing-your-swift-code-like-a-fashionista-c07127fc4dd4

import UIKit

// The Decorator Pattern dynamically adds responsibilities to objects.

protocol Outfit {
    func description() -> String
    func cost() -> Double
}

class BasicOutfit: Outfit {
    func description() -> String {
        return "Basic jeans and tee"
    }
    
    func cost() -> Double {
        return 50.0
    }
}

class Accessory: Outfit {
    private let outfit: Outfit
    let accessoryDescription: String
    let accessoryCost: Double
    
    init(_ outfit: Outfit, description: String, cost: Double) {
        self.outfit = outfit
        self.accessoryDescription = description
        self.accessoryCost = cost
    }
    
    func description() -> String {
        return "\(outfit.description()), accessorized with \(accessoryDescription)"
    }
    
    func cost() -> Double {
        return outfit.cost() + accessoryCost
    }
}

let myOutfit = BasicOutfit()

let decoratedOutfit = Accessory(myOutfit, description: "a snazzy scarf", cost: 20.0)

print(decoratedOutfit.description())  // "Basic jeans and tee, accessorized with a snazzy scarf"

print(decoratedOutfit.cost())  // 70.0Why Stop at One? Layer Like a Pro!


// https://levelup.gitconnected.com/brewing-up-swift-magic-with-real-world-design-patterns-47c680041efa

/*
 The Decorator Design Pattern

 The Decorator pattern is a structural design pattern that allows behavior to be added to individual objects, either statically or dynamically, without affecting the behavior of other objects from the same class. It is achieved by creating a set of decorator classes that are used to wrap concrete components.
 The Real-World Analogy: Customizing Your Coffee

 Imagine you enter a coffee shop, and you have the option to customize your coffee. The base coffee represents the core functionality, and each decorator adds a unique twist, whether it’s extra flavor, a dash of sweetness, or a layer of frothy goodness. This ability to dynamically customize your coffee without altering its fundamental nature mirrors the Decorator pattern.
 
 The Components of the Analogy

     Base Coffee (Concrete Component): This is the base coffee you start with, representing the core functionality.
     Decorators (Concrete Decorators): Each decorator represents a customization option. It wraps around the base coffee, adding specific features or modifications.
     Customized Coffee (Decorated Component): The final product is your customized coffee, combining the base coffee and the selected decorators.
 */

// 1. Base Coffee (Concrete Component)
protocol Coffee {
    func cost() -> Double
    func description() -> String
}

class SimpleCoffee: Coffee {
    func cost() -> Double {
        return 2.0
    }

    func description() -> String {
        return "Simple Coffee"
    }
}

// 2. Decorators (Concrete Decorators)
protocol CoffeeDecorator: Coffee {
    var baseCoffee: Coffee { get }
    init(baseCoffee: Coffee)
}

class MilkDecorator: CoffeeDecorator {
    var baseCoffee: Coffee

    required init(baseCoffee: Coffee) {
        self.baseCoffee = baseCoffee
    }

    func cost() -> Double {
        return baseCoffee.cost() + 1.0
    }

    func description() -> String {
        return baseCoffee.description() + ", with Milk"
    }
}

class SugarDecorator: CoffeeDecorator {
    var baseCoffee: Coffee

    required init(baseCoffee: Coffee) {
        self.baseCoffee = baseCoffee
    }

    func cost() -> Double {
        return baseCoffee.cost() + 0.5
    }

    func description() -> String {
        return baseCoffee.description() + ", with Sugar"
    }
}

// 3. Customized Coffee (Decorated Component)
let simpleCoffee = SimpleCoffee()
let milkCoffee = MilkDecorator(baseCoffee: simpleCoffee)
let sugarMilkCoffee = SugarDecorator(baseCoffee: milkCoffee)

print("Cost: $\(sugarMilkCoffee.cost())")
print("Description: \(sugarMilkCoffee.description())")
