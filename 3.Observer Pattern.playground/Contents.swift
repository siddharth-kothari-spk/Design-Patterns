//courtsey: https://medium.com/@mihail_salari/3-20-observer-pattern-in-ios-the-neighborhood-gossip-chain-4a2e0c98463f

import UIKit

// In Observer pattern , when an object (subject) changes its state, all registered observers are automatically notified.

protocol GossipListener: class {
    func gossipDidChange(latestGossip: String)
}

class TownCrier {
    private var listeners: [GossipListener] = []
    var latestGossip: String = "" {
        didSet {
            notifyListeners()
        }
    }
    func addListener(_ listener: GossipListener) {
        listeners.append(listener)
    }
    private func notifyListeners() {
        for listener in listeners {
            listener.gossipDidChange(latestGossip: latestGossip)
        }
    }
}
class NosyNeighbor: GossipListener {
    func gossipDidChange(latestGossip: String) {
        print("Did you hear? \(latestGossip)")
    }
}
let townCrier = TownCrier()
let missPenny = NosyNeighbor()
townCrier.addListener(missPenny)
townCrier.latestGossip = "Mr. Smith got a new hat!"
// output : Did you hear? Mr. Smith got a new hat!

/*
 Pros:

     In the Loop: Everyone is updated in real-time.
     Decoupling: The town crier doesn’t need to know every neighbor personally; he just shouts!

 Cons:

     Too Much Noise: Too many notifications can lead to a lot of chatter.
     Memory Leaks: Nosy neighbors might forget to stop listening, leading to wasted resources.
 */
