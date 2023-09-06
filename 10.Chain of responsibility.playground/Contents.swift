//https://medium.com/@mihail_salari/10-20-the-chain-of-responsibility-pattern-passing-the-magical-torch-in-swift-fbf6121c82aa
import UIKit

// In  Chain of Responsibility pattern, objects are linked, passing requests along until one of them handles it.

protocol MagicalItem {
    var nextInChain: MagicalItem? { get set }
    func enchant(request: String) -> String?
}

class FireStaff: MagicalItem {
    var nextInChain: MagicalItem?
    func enchant(request: String) -> String? {
        if request == "Fireball" {
            return "Casting Fireball! 🔥"
        }
        return nextInChain?.enchant(request: request)
    }
}

class IceAmulet: MagicalItem {
    var nextInChain: MagicalItem?
    func enchant(request: String) -> String? {
        if request == "Freeze" {
            return "Casting Freeze! ❄️"
        }
        return nextInChain?.enchant(request: request)
    }
}

let staff = FireStaff()
let amulet = IceAmulet()

staff.nextInChain = amulet

print(staff.enchant(request: "Fireball")!) // "Casting Fireball! 🔥"
print(staff.enchant(request: "Freeze")!)   // "Casting Freeze! ❄️"

/*
 Advantages:
 Decouples senders from receivers: You don’t need to know which magical item handles the request.
 Dynamic chaining: Alter the chain’s order or introduce new items without changing the existing code.
 Streamlined magic handling: Each item is only concerned with its enchantment, keeping code clean and focused.
 */
