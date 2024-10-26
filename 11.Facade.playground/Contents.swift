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

//https://refactoring.guru/design-patterns/facade
//Facade is a structural design pattern that provides a simplified interface to a library, a framework, or any other complex set of classes.

import XCTest

/// Facade Design Pattern
///
/// Intent: Provides a simplified interface to a library, a framework, or any
/// other complex set of classes.

class FacadeRealWorld: XCTestCase {

    /// In the real project, you probably will use third-party libraries. For
    /// instance, to download images.
    ///
    /// Therefore, facade and wrapping it is a good way to use a third party API
    /// in the client code. Even if it is your own library that is connected to
    /// a project.
    ///
    /// The benefits here are:
    ///
    /// 1) If you need to change a current image downloader it should be done
    /// only in the one place of a project. A number of lines of the client code
    /// will stay work.
    ///
    /// 2) The facade provides an access to a fraction of a functionality that
    /// fits most client needs. Moreover, it can set frequently used or default
    /// parameters.

    func testFacedeRealWorld() {

        let imageView = UIImageView()

        print("Let's set an image for the image view")

        clientCode(imageView)

        print("Image has been set")

        XCTAssert(imageView.image != nil)
    }

    fileprivate func clientCode(_ imageView: UIImageView) {

        let url = URL(string: "www.example.com/logo")
        imageView.downloadImage(at: url)
    }
}

private extension UIImageView {

    /// This extension plays a facede role.

    func downloadImage(at url: URL?) {

        print("Start downloading...")

        let placeholder = UIImage(named: "placeholder")

        ImageDownloader().loadImage(at: url,
                                    placeholder: placeholder,
                                    completion: { image, error in
            print("Handle an image...")

            /// Crop, cache, apply filters, whatever...

            self.image = image
        })
    }
}

private class ImageDownloader {

    /// Third party library or your own solution (subsystem)

    typealias Completion = (UIImage, Error?) -> ()
    typealias Progress = (Int, Int) -> ()

    func loadImage(at url: URL?,
                   placeholder: UIImage? = nil,
                   progress: Progress? = nil,
                   completion: Completion) {
        /// ... Set up a network stack
        /// ... Downloading an image
        /// ...
        completion(UIImage(), nil)
    }

