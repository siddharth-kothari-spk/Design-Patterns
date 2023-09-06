// https://medium.com/@mihail_salari/6-20-copycats-with-the-prototype-design-pattern-clone-wars-in-swift-ff0beb95c969

import UIKit

// The Prototype pattern lets you create objects by copying an existing object, the prototype

protocol SuperheroPrototype {
    var name: String { get set }
    var superPower: String { get set }
    
    func clone() -> SuperheroPrototype
}

class SwiftMan: SuperheroPrototype {
    var name: String
    var superPower: String
    init(name: String, superPower: String) {
        self.name = name
        self.superPower = superPower
    }
    
    func clone() -> SuperheroPrototype {
        return SwiftMan(name: self.name, superPower: self.superPower)
    }
}
// Let's clone!
let originalSwiftMan = SwiftMan(name: "SwiftMan", superPower: "Codes in the blink of an eye!")
let clonedSwiftMan = originalSwiftMan.clone()
print(clonedSwiftMan.name) // Prints: "SwiftMan"

