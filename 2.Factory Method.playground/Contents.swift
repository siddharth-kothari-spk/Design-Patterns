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
