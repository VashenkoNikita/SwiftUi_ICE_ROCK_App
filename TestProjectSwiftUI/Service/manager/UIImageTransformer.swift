//
//  UIImageTransformer.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 07.09.2022.
//

import UIKit

@objc(UIImageTransformer)
class UIImageTransformer: NSSecureUnarchiveFromDataTransformer {
    public static let name = NSValueTransformerName(rawValue: String(describing: UIImageTransformer.self))
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override class func transformedValueClass() -> AnyClass {
        return UIImage.self
    }
    
    override class var allowedTopLevelClasses: [AnyClass] {
        return [UIImage.self]
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else {
            fatalError("Wrong data type: value must be a Data object; received \(type(of: value))")
        }
        return super.transformedValue(data)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let image = value as? UIImage else {
            fatalError("Wrong data type: value must be a UIImage object; received \(type(of: value))")
        }
        return super.reverseTransformedValue(image)
    }
    //Register before CoreData setup starts
    @objc dynamic
    public static func register() {

        let transformer = UIImageTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
