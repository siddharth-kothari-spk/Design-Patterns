// https://medium.com/@mihail_salari/12-20-the-flyweight-pattern-slimming-down-your-swift-apps-fe75eb22e7aa
/*
 What is the Flyweight Pattern? 🪶

 The Flyweight Pattern is akin to a magical wardrobe that offers an exquisite array of costumes (data) designed to be shared among multiple dancers (objects) to reduce the weight of their attire (memory usage). This pattern excels in environments where the illusion of unique object instances is maintained, while in reality, shared data keeps the application light on its feet.
 */

// Defining the Flyweight
class Costume {
    var design: String // Shared data
    init(design: String) {
        self.design = design
    }
}

// Costume Factory - ensuring costumes are shared efficiently
class CostumeFactory {
    private var costumes: [String: Costume] = [:]
    func getCostume(forDesign design: String) -> Costume {
        if let costume = costumes[design] {
            return costume
        } else {
            let newCostume = Costume(design: design)
            costumes[design] = newCostume
            return newCostume
        }
    }
}
