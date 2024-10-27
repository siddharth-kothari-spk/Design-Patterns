// https://refactoring.guru/design-patterns/memento
// Memento is a behavioral design pattern that lets you save and restore the previous state of an object without revealing the details of its implementation.

import XCTest

/// The Originator holds some important state that may change over time. It also
/// defines a method for saving the state inside a memento and another method
/// for restoring the state from it.
class Originator {

    /// For the sake of simplicity, the originator's state is stored inside a
    /// single variable.
    private var state: String

    init(state: String) {
        self.state = state
        print("Originator: My initial state is: \(state)")
    }

    /// The Originator's business logic may affect its internal state.
    /// Therefore, the client should backup the state before launching methods
    /// of the business logic via the save() method.
    func doSomething() {
        print("Originator: I'm doing something important.")
        state = generateRandomString()
        print("Originator: and my state has changed to: \(state)")
    }

    private func generateRandomString() -> String {
        return String(UUID().uuidString.suffix(4))
    }

    /// Saves the current state inside a memento.
    func save() -> Memento {
        return ConcreteMemento(state: state)
    }

    /// Restores the Originator's state from a memento object.
    func restore(memento: Memento) {
        guard let memento = memento as? ConcreteMemento else { return }
        self.state = memento.state
        print("Originator: My state has changed to: \(state)")
    }
}

/// The Memento interface provides a way to retrieve the memento's metadata,
/// such as creation date or name. However, it doesn't expose the Originator's
/// state.
protocol Memento {

    var name: String { get }
    var date: Date { get }
}

/// The Concrete Memento contains the infrastructure for storing the
/// Originator's state.
class ConcreteMemento: Memento {

    /// The Originator uses this method when restoring its state.
    private(set) var state: String
    private(set) var date: Date

    init(state: String) {
        self.state = state
        self.date = Date()
    }

    /// The rest of the methods are used by the Caretaker to display metadata.
    var name: String { return state + " " + date.description.suffix(14).prefix(8) }
}

/// The Caretaker doesn't depend on the Concrete Memento class. Therefore, it
/// doesn't have access to the originator's state, stored inside the memento. It
/// works with all mementos via the base Memento interface.
class Caretaker {

    private lazy var mementos = [Memento]()
    private var originator: Originator

    init(originator: Originator) {
        self.originator = originator
    }

    func backup() {
        print("\nCaretaker: Saving Originator's state...\n")
        mementos.append(originator.save())
    }

    func undo() {

        guard !mementos.isEmpty else { return }
        let removedMemento = mementos.removeLast()

        print("Caretaker: Restoring state to: " + removedMemento.name)
        originator.restore(memento: removedMemento)
    }

    func showHistory() {
        print("Caretaker: Here's the list of mementos:\n")
        mementos.forEach({ print($0.name) })
    }
}

/// Let's see how it all works together.
class MementoConceptual: XCTestCase {

    func testMementoConceptual() {

        let originator = Originator(state: "Super-duper-super-puper-super.")
        let caretaker = Caretaker(originator: originator)

        caretaker.backup()
        originator.doSomething()

        caretaker.backup()
        originator.doSomething()

        caretaker.backup()
        originator.doSomething()

        print("\n")
        caretaker.showHistory()

        print("\nClient: Now, let's rollback!\n\n")
        caretaker.undo()

        print("\nClient: Once more!\n\n")
        caretaker.undo()
    }
}



// Sample 2
import XCTest

class MementoRealWorld: XCTestCase {

    /// State and Command are often used together when the previous state of the
    /// object should be restored in case of failure of some operation.
    ///
    /// Note: UndoManager can be used as an alternative.

    func test() {

        let textView = UITextView()
        let undoStack = UndoStack(textView)

        textView.text = "First Change"
        undoStack.save()

        textView.text = "Second Change"
        undoStack.save()

        textView.text = (textView.text ?? "") + " & Third Change"
        textView.textColor = .red
        undoStack.save()

        print(undoStack)

        print("Client: Perform Undo operation 2 times\n")
        undoStack.undo()
        undoStack.undo()

        print(undoStack)
    }
}

class UndoStack: CustomStringConvertible {

    private lazy var mementos = [Memento]()
    private let textView: UITextView

    init(_ textView: UITextView) {
        self.textView = textView
    }

    func save() {
        mementos.append(textView.memento)
    }

    func undo() {
        guard !mementos.isEmpty else { return }
        textView.restore(with: mementos.removeLast())
    }

    var description: String {
        return mementos.reduce("", { $0 + $1.description })
    }
}

protocol Memento: CustomStringConvertible {

    var text: String { get }
    var date: Date { get }
}

extension UITextView {

    var memento: Memento {
        return TextViewMemento(text: text,
                               textColor: textColor,
                               selectedRange: selectedRange)
    }

    func restore(with memento: Memento) {
        guard let textViewMemento = memento as? TextViewMemento else { return }

        text = textViewMemento.text
        textColor = textViewMemento.textColor
        selectedRange = textViewMemento.selectedRange
    }

    struct TextViewMemento: Memento {

        let text: String
        let date = Date()

        let textColor: UIColor?
        let selectedRange: NSRange

        var description: String {
            let time = Calendar.current.dateComponents([.hour, .minute, .second, .nanosecond],
                                                       from: date)
            let color = String(describing: textColor)
            return "Text: \(text)\n" + "Date: \(time.description)\n"
                + "Color: \(color)\n" + "Range: \(selectedRange)\n\n"
        }
    }
}
