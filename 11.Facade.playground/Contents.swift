// https://medium.com/@mihail_salari/11-20-the-facade-pattern-simplifying-swift-with-a-magic-wand-%EF%B8%8F-d1c7d11b07d8

/*
 What is the Facade Pattern? 🏰
 In the realm of software development, the Facade Pattern serves as a front-facing interface, a simplifying layer that hides the intricate and often convoluted systems lurking beneath. It’s like having a trusty guide in a dense forest, one who knows all the shortcuts and paths to lead you safely to your destination without facing the perilous beasts of complexity and boilerplate code.
 
 
 */

// Defining the subsystems
class TreasuryDepartment {
    func manageFinances() -> String { "Managing the kingdom's treasury." }
}

class DefenseDepartment {
    func protectRealm() -> String { "Defending the kingdom from dragons and invaders." }
}
class ScienceDepartment {
    func advanceTechnology() -> String { "Innovating for a brighter tomorrow." }
}
// The Facade
class KingdomFacade {
    let treasury = TreasuryDepartment()
    let defense = DefenseDepartment()
    let science = ScienceDepartment()
    func overseeKingdom() -> String {
        let finances = treasury.manageFinances()
        let protection = defense.protectRealm()
        let innovation = science.advanceTechnology()
        return "\(finances)\n\(protection)\n\(innovation)"
    }
}

let kingdom = KingdomFacade()
print(kingdom.overseeKingdom())
