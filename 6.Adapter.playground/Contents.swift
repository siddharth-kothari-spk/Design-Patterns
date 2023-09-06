// https://medium.com/@mihail_salari/6-20-the-adapter-pattern-converting-wizards-to-muggles-in-swift-473e831c0359
import UIKit

// The Adapter Pattern is all about letting incompatible interfaces work together.

protocol Dragon {
    func roar() -> String
}

protocol Unicorn {
    func sparkleTalk() -> String
}

class FireDragon: Dragon {
    func roar() -> String {
        return "Blazing Roar!"
    }
}

class RainbowUnicorn: Unicorn {
    func sparkleTalk() -> String {
        return "Twinkle Chat!"
    }
}

// Adapter magic begins...
class UnicornAdapter: Dragon {
    private let unicorn: Unicorn
    
    init(_ unicorn: Unicorn) {
        self.unicorn = unicorn
    }
    
    func roar() -> String {
        return unicorn.sparkleTalk()
    }
}

let ruby = FireDragon()

print(ruby.roar())  // Blazing Roar!

let starlight = RainbowUnicorn()
let adaptedStarlight = UnicornAdapter(starlight)

print(adaptedStarlight.roar())  // Twinkle Chat!
