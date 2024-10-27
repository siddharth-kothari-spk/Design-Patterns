// https://refactoring.guru/design-patterns/template-method/swift/example#example-0

// Template Method is a behavioral design pattern that allows you to define a skeleton of an algorithm in a base class and let subclasses override the steps without changing the overall algorithm’s structure.

import XCTest


/// The Abstract Protocol and its extension defines a template method that
/// contains a skeleton of some algorithm, composed of calls to (usually)
/// abstract primitive operations.
///
/// Concrete subclasses should implement these operations, but leave the
/// template method itself intact.
protocol AbstractProtocol {

    /// The template method defines the skeleton of an algorithm.
    func templateMethod()

    /// These operations already have implementations.
    func baseOperation1()

    func baseOperation2()

    func baseOperation3()

    /// These operations have to be implemented in subclasses.
    func requiredOperations1()
    func requiredOperation2()

    /// These are "hooks." Subclasses may override them, but it's not mandatory
    /// since the hooks already have default (but empty) implementation. Hooks
    /// provide additional extension points in some crucial places of the
    /// algorithm.
    func hook1()
    func hook2()
}

extension AbstractProtocol {

    func templateMethod() {
        baseOperation1()
        requiredOperations1()
        baseOperation2()
        hook1()
        requiredOperation2()
        baseOperation3()
        hook2()
    }

    /// These operations already have implementations.
    func baseOperation1() {
        print("AbstractProtocol says: I am doing the bulk of the work\n")
    }

    func baseOperation2() {
        print("AbstractProtocol says: But I let subclasses override some operations\n")
    }

    func baseOperation3() {
        print("AbstractProtocol says: But I am doing the bulk of the work anyway\n")
    }

    func hook1() {}
    func hook2() {}
}

/// Concrete classes have to implement all abstract operations of the base
/// class. They can also override some operations with a default implementation.
class ConcreteClass1: AbstractProtocol {

    func requiredOperations1() {
        print("ConcreteClass1 says: Implemented Operation1\n")
    }

    func requiredOperation2() {
        print("ConcreteClass1 says: Implemented Operation2\n")
    }

    func hook2() {
        print("ConcreteClass1 says: Overridden Hook2\n")
    }
}

/// Usually, concrete classes override only a fraction of base class'
/// operations.
class ConcreteClass2: AbstractProtocol {

    func requiredOperations1() {
        print("ConcreteClass2 says: Implemented Operation1\n")
    }

    func requiredOperation2() {
        print("ConcreteClass2 says: Implemented Operation2\n")
    }

    func hook1() {
        print("ConcreteClass2 says: Overridden Hook1\n")
    }
}

/// The client code calls the template method to execute the algorithm. Client
/// code does not have to know the concrete class of an object it works with, as
/// long as it works with objects through the interface of their base class.
class Client {
    // ...
    static func clientCode(use object: AbstractProtocol) {
        // ...
        object.templateMethod()
        // ...
    }
    // ...
}


/// Let's see how it all works together.
class TemplateMethodConceptual: XCTestCase {

    func test() {

        print("Same client code can work with different subclasses:\n")
        Client.clientCode(use: ConcreteClass1())

        print("\nSame client code can work with different subclasses:\n")
        Client.clientCode(use: ConcreteClass2())
    }
}


// sample 2

import XCTest
import AVFoundation
import CoreLocation
import Photos

class TemplateMethodRealWorld: XCTestCase {

    /// A good example of Template Method is a life cycle of UIViewController

    func testTemplateMethodReal() {

        let accessors = [CameraAccessor(), MicrophoneAccessor(), PhotoLibraryAccessor()]

        accessors.forEach { item in
            item.requestAccessIfNeeded({ status in
                let message = status ? "You have access to " : "You do not have access to "
                print(message + item.description + "\n")
            })
        }
    }
}

class PermissionAccessor: CustomStringConvertible {

    typealias Completion = (Bool) -> ()

    func requestAccessIfNeeded(_ completion: @escaping Completion) {

        guard !hasAccess() else { completion(true); return }

        willReceiveAccess()

        requestAccess { status in
            status ? self.didReceiveAccess() : self.didRejectAccess()

            completion(status)
        }
    }

    func requestAccess(_ completion: @escaping Completion) {
        fatalError("Should be overridden")
    }

    func hasAccess() -> Bool {
        fatalError("Should be overridden")
    }

    var description: String { return "PermissionAccessor" }

    /// Hooks
    func willReceiveAccess() {}

    func didReceiveAccess() {}

    func didRejectAccess() {}
}

class CameraAccessor: PermissionAccessor {

    override func requestAccess(_ completion: @escaping Completion) {
        AVCaptureDevice.requestAccess(for: .video) { status in
            return completion(status)
        }
    }

    override func hasAccess() -> Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }

    override var description: String { return "Camera" }
}

class MicrophoneAccessor: PermissionAccessor {

    override func requestAccess(_ completion: @escaping Completion) {
//        AVAudioSession.sharedInstance().requestRecordPermission { status in
//            completion(status)
//        }
        AVAudioApplication.requestRecordPermission { status in
            completion(status)
        }
    }

    override func hasAccess() -> Bool {
      //  return AVAudioSession.sharedInstance().recordPermission == .granted
        return AVAudioApplication.recordPermission.granted == .granted
    }

    override var description: String { return "Microphone" }
}

class PhotoLibraryAccessor: PermissionAccessor {

    override func requestAccess(_ completion: @escaping Completion) {
        PHPhotoLibrary.requestAuthorization { status in
            completion(status == .authorized)
        }
    }

    override func hasAccess() -> Bool {
        return PHPhotoLibrary.authorizationStatus() == .authorized
    }

    override var description: String { return "PhotoLibrary" }

    override func didReceiveAccess() {
        /// We want to track how many people give access to the PhotoLibrary.
        print("PhotoLibrary Accessor: Receive access. Updating analytics...")
    }

    override func didRejectAccess() {
        /// ... and also we want to track how many people rejected access.
        print("PhotoLibrary Accessor: Rejected with access. Updating analytics...")
    }
}
