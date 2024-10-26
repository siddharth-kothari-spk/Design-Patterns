// https://medium.com/@mihail_salari/7-20-the-decorator-pattern-accessorizing-your-swift-code-like-a-fashionista-c07127fc4dd4

import UIKit

// The Decorator Pattern dynamically adds responsibilities to objects.

protocol Outfit {
    func description() -> String
    func cost() -> Double
}

class BasicOutfit: Outfit {
    func description() -> String {
        return "Basic jeans and tee"
    }
    
    func cost() -> Double {
        return 50.0
    }
}

class Accessory: Outfit {
    private let outfit: Outfit
    let accessoryDescription: String
    let accessoryCost: Double
    
    init(_ outfit: Outfit, description: String, cost: Double) {
        self.outfit = outfit
        self.accessoryDescription = description
        self.accessoryCost = cost
    }
    
    func description() -> String {
        return "\(outfit.description()), accessorized with \(accessoryDescription)"
    }
    
    func cost() -> Double {
        return outfit.cost() + accessoryCost
    }
}

let myOutfit = BasicOutfit()

let decoratedOutfit = Accessory(myOutfit, description: "a snazzy scarf", cost: 20.0)

print(decoratedOutfit.description())  // "Basic jeans and tee, accessorized with a snazzy scarf"

print(decoratedOutfit.cost())  // 70.0Why Stop at One? Layer Like a Pro!


// https://levelup.gitconnected.com/brewing-up-swift-magic-with-real-world-design-patterns-47c680041efa

/*
 The Decorator Design Pattern

 The Decorator pattern is a structural design pattern that allows behavior to be added to individual objects, either statically or dynamically, without affecting the behavior of other objects from the same class. It is achieved by creating a set of decorator classes that are used to wrap concrete components.
 The Real-World Analogy: Customizing Your Coffee

 Imagine you enter a coffee shop, and you have the option to customize your coffee. The base coffee represents the core functionality, and each decorator adds a unique twist, whether it’s extra flavor, a dash of sweetness, or a layer of frothy goodness. This ability to dynamically customize your coffee without altering its fundamental nature mirrors the Decorator pattern.
 
 The Components of the Analogy

     Base Coffee (Concrete Component): This is the base coffee you start with, representing the core functionality.
     Decorators (Concrete Decorators): Each decorator represents a customization option. It wraps around the base coffee, adding specific features or modifications.
     Customized Coffee (Decorated Component): The final product is your customized coffee, combining the base coffee and the selected decorators.
 */

// 1. Base Coffee (Concrete Component)
protocol Coffee {
    func cost() -> Double
    func description() -> String
}

class SimpleCoffee: Coffee {
    func cost() -> Double {
        return 2.0
    }

    func description() -> String {
        return "Simple Coffee"
    }
}

// 2. Decorators (Concrete Decorators)
protocol CoffeeDecorator: Coffee {
    var baseCoffee: Coffee { get }
    init(baseCoffee: Coffee)
}

class MilkDecorator: CoffeeDecorator {
    var baseCoffee: Coffee

    required init(baseCoffee: Coffee) {
        self.baseCoffee = baseCoffee
    }

    func cost() -> Double {
        return baseCoffee.cost() + 1.0
    }

    func description() -> String {
        return baseCoffee.description() + ", with Milk"
    }
}

class SugarDecorator: CoffeeDecorator {
    var baseCoffee: Coffee

    required init(baseCoffee: Coffee) {
        self.baseCoffee = baseCoffee
    }

    func cost() -> Double {
        return baseCoffee.cost() + 0.5
    }

    func description() -> String {
        return baseCoffee.description() + ", with Sugar"
    }
}

// 3. Customized Coffee (Decorated Component)
let simpleCoffee = SimpleCoffee()
let milkCoffee = MilkDecorator(baseCoffee: simpleCoffee)
let sugarMilkCoffee = SugarDecorator(baseCoffee: milkCoffee)

print("Cost: $\(sugarMilkCoffee.cost())")
print("Description: \(sugarMilkCoffee.description())")


// https://refactoring.guru/design-patterns/decorator/swift/example
//Decorator is a structural pattern that allows adding new behaviors to objects dynamically by placing them inside special wrapper objects, called decorators.

import UIKit
import XCTest


protocol ImageEditor: CustomStringConvertible {

    func apply() -> UIImage
}

class ImageDecorator: ImageEditor {

    private var editor: ImageEditor

    required init(_ editor: ImageEditor) {
        self.editor = editor
    }

    func apply() -> UIImage {
        print(editor.description + " applies changes")
        return editor.apply()
    }

    var description: String {
        return "ImageDecorator"
    }
}

extension UIImage: ImageEditor {

    func apply() -> UIImage {
        return self
    }

    open override var description: String {
        return "Image"
    }
}



class BaseFilter: ImageDecorator {

    fileprivate var filter: CIFilter?

    init(editor: ImageEditor, filterName: String) {
        self.filter = CIFilter(name: filterName)
        super.init(editor)
    }

    required init(_ editor: ImageEditor) {
        super.init(editor)
    }

    override func apply() -> UIImage {

        let image = super.apply()
        let context = CIContext(options: nil)

        filter?.setValue(CIImage(image: image), forKey: kCIInputImageKey)

        guard let output = filter?.outputImage else { return image }
        guard let coreImage = context.createCGImage(output, from: output.extent) else {
            return image
        }
        return UIImage(cgImage: coreImage)
    }

    override var description: String {
        return "BaseFilter"
    }
}

class BlurFilter: BaseFilter {

    required init(_ editor: ImageEditor) {
        super.init(editor: editor, filterName: "CIGaussianBlur")
    }

    func update(radius: Double) {
        filter?.setValue(radius, forKey: "inputRadius")
    }

    override var description: String {
        return "BlurFilter"
    }
}

class ColorFilter: BaseFilter {

    required init(_ editor: ImageEditor) {
        super.init(editor: editor, filterName: "CIColorControls")
    }

    func update(saturation: Double) {
        filter?.setValue(saturation, forKey: "inputSaturation")
    }

    func update(brightness: Double) {
        filter?.setValue(brightness, forKey: "inputBrightness")
    }

    func update(contrast: Double) {
        filter?.setValue(contrast, forKey: "inputContrast")
    }

    override var description: String {
        return "ColorFilter"
    }
}

class Resizer: ImageDecorator {

    private var xScale: CGFloat = 0
    private var yScale: CGFloat = 0
    private var hasAlpha = false

    convenience init(_ editor: ImageEditor, xScale: CGFloat = 0, yScale: CGFloat = 0, hasAlpha: Bool = false) {
        self.init(editor)
        self.xScale = xScale
        self.yScale = yScale
        self.hasAlpha = hasAlpha
    }

    required init(_ editor: ImageEditor) {
        super.init(editor)
    }

    override func apply() -> UIImage {

        let image = super.apply()

        let size = image.size.applying(CGAffineTransform(scaleX: xScale, y: yScale))

        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, UIScreen.main.scale)
        image.draw(in: CGRect(origin: .zero, size: size))

        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return scaledImage ?? image
    }

    override var description: String {
        return "Resizer"
    }
}


class DecoratorRealWorld: XCTestCase {

    func testDecoratorRealWorld() {

        let image = loadImage()

        print("Client: set up an editors stack")
        let resizer = Resizer(image, xScale: 0.2, yScale: 0.2)

        let blurFilter = BlurFilter(resizer)
        blurFilter.update(radius: 2)

        let colorFilter = ColorFilter(blurFilter)
        colorFilter.update(contrast: 0.53)
        colorFilter.update(brightness: 0.12)
        colorFilter.update(saturation: 4)

        clientCode(editor: colorFilter)
    }

    func clientCode(editor: ImageEditor) {
        let image = editor.apply()
        /// Note. You can stop an execution in Xcode to see an image preview.
        print("Client: all changes have been applied for \(image)")
    }
}

private extension DecoratorRealWorld {

    func loadImage() -> UIImage {

        let urlString = "https:// refactoring.guru/images/content-public/logos/logo-new-3x.png"

        /// Note:
        /// Do not download images the following way in a production code.

        guard let url = URL(string: urlString) else {
            fatalError("Please enter a valid URL")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Cannot load an image")
        }

        guard let image = UIImage(data: data) else {
            fatalError("Cannot create an image from data")
        }
        return image
    }
}
