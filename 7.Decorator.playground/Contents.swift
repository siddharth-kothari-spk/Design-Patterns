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


