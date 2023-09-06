// courtsey: https://medium.com/@mihail_salari/1-20-the-singleton-chronicles-the-one-ring-of-ios-design-patterns-22941a3e5cc6

import UIKit

// Singleton ensures that a particular class has only one instance and provides a way to access its instance from anywhere in the code.

class MagicalCat {
    static let whiskers = MagicalCat()
    
    private init() { }
    
    func purr() {
        print("Purrrrr...")
    }
}

MagicalCat.whiskers.purr()
/*
 Benefits of Singleton 🌟

     Shared Access: Like the community fridge in your office (that’s always filled with mysterious leftovers), any part of your app can access the Singleton.
     State Management: If our universal remote had a “last-used” feature, it would be consistent, no matter who accessed it last.
     Resource Management: Sometimes, creating multiple instances can be expensive. With Singletons, you’re just managing one.
 
 
 Caveats of Singleton 🚧

     Overuse: Just because you can use Whiskers for everything doesn’t mean you should. Over-reliance on Singletons can make your code harder to test and maintain.
     Multi-threading: If two kids call Whiskers at the same time from opposite ends of town, chaos might ensue! Ensure your Singletons are thread-safe.
 
 
 Pros:

     Consistency: Just like Singy’s unchanging dance move, singletons provide consistent access to resources.
     Easy Access: Call upon Singy from anywhere in the app without the need to instantiate him repeatedly.

 Cons:

     Overuse: Too much of anything is bad. Using singletons for everything makes your code hard to test and manage.
     State Management: Just like Singy can get tired dancing forever, managing a singleton’s state can be tricky.
 */

