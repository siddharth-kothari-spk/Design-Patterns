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

// https://refactoring.guru/design-patterns/prototype/swift/example#example-1
// Prototype is a creational design pattern that allows cloning objects, even complex ones, without coupling to their specific classes.

/// Swift has built-in cloning support. To add cloning support to your class,
/// you need to implement the NSCopying protocol in that class and provide the
/// implementation for the `copy` method.
/// 
import XCTest

private class Page: NSCopying {

    private(set) var title: String
    private(set) var contents: String
    private weak var author: Author?
    private(set) var comments = [Comment]()

    init(title: String, contents: String, author: Author?) {
        self.title = title
        self.contents = contents
        self.author = author
        author?.add(page: self)
    }

    func add(comment: Comment) {
        comments.append(comment)
    }

    /// MARK: - NSCopying

    func copy(with zone: NSZone? = nil) -> Any {
        return Page(title: "Copy of '" + title + "'", contents: contents, author: author)
    }
}

private class Author {

    private var id: Int
    private var username: String
    private var pages = [Page]()

    init(id: Int, username: String) {
        self.id = id
        self.username = username
    }

    func add(page: Page) {
        pages.append(page)
    }

    var pagesCount: Int {
        return pages.count
    }
}



private struct Comment {

    let date = Date()
    let message: String
}

class PrototypeRealWorld: XCTestCase {

    func testPrototypeRealWorld() {

        let author = Author(id: 10, username: "Ivan_83")
        let page = Page(title: "My First Page", contents: "Hello world!", author: author)

        page.add(comment: Comment(message: "Keep it up!"))

        /// Since NSCopying returns Any, the copied object should be unwrapped.
        guard let anotherPage = page.copy() as? Page else {
            XCTFail("Page was not copied")
            return
        }

        /// Comments should be empty as it is a new page.
        XCTAssert(anotherPage.comments.isEmpty)

        /// Note that the author is now referencing two objects.
        XCTAssert(author.pagesCount == 2)

        print("Original title: " + page.title)
        print("Copied title: " + anotherPage.title)
        print("Count of pages: " + String(author.pagesCount))
    }
}
