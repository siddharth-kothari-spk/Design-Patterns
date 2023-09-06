//https://medium.com/@mihail_salari/9-20-the-strategy-pattern-pick-your-gameplay-strategy-slay-1dd1f9693d85
import UIKit

//The Strategy Pattern allows an algorithm’s implementation to be selected at runtime.

// Strategy Protocol
protocol BattleStrategy {
    func execute() -> String
}

class StealthAttack: BattleStrategy {
    func execute() -> String {
        return "Attacking with stealth! 🕶️"
    }
}

class DirectCombat: BattleStrategy {
    func execute() -> String {
        return "Engaging in direct combat! 🗡️"
    }
}

class GameCharacter {
    var strategy: BattleStrategy
    
    init(strategy: BattleStrategy) {
        self.strategy = strategy
    }
    
    func attack() -> String {
        return strategy.execute()
    }
}

let ninja = GameCharacter(strategy: StealthAttack())
print(ninja.attack()) // "Attacking with stealth! 🕶️"

let knight = GameCharacter(strategy: DirectCombat())
print(knight.attack()) // "Engaging in direct combat! 🗡️"

