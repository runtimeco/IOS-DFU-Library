//
//  EVWorkaroundHelpers.swift
//  EVReflection
//
//  Created by Edwin Vermeer on 2/7/16.
//  Copyright © 2016 evict. All rights reserved.
//

import Foundation


/**
 Protocol for the workaround when using generics. See WorkaroundSwiftGenericsTests.swift
 */
internal protocol EVGenericsKVC {
    /**
     Implement this protocol in a class with generic properties so that we can still use a standard mechanism for setting property values.
     */
    func setValue(value: AnyObject!, forUndefinedKey key: String)
}

/**
 Protocol for the workaround when using an enum with a rawValue of type Int
 */
internal protocol EVRawInt {
    /**
     Protocol EVRawString can be added to an Enum that has Int as it's rawValue so that we can detect from a generic enum what it's rawValue is.
     */
    var rawValue: Int { get }
}

/**
 Protocol for the workaround when using an enum with a rawValue of type String
 */
internal protocol EVRawString {
    /**
     Protocol EVRawString can be added to an Enum that has String as it's rawValue so that we can detect from a generic enum what it's rawValue is.
     */
    var rawValue: String { get }
}

/**
 Protocol for the workaround when using an enum with a rawValue of an undefined type
 */
internal protocol EVRaw {
    /**
     For implementing a function that will return the rawValue for a non sepecific enum
     */
    var anyRawValue: Any { get }
}

/**
 Protocol for the workaround when using an array with nullable values
 */
internal protocol EVArrayConvertable {
    /**
     For implementing a function for converting a generic array to a specific array.
     */
    func convertArray(key: String, array: Any) -> NSArray
}


/**
 Add a property to an enum to get the associated value
 */
internal protocol EVAssociated {
}

/**
 The implrementation of the protocol for getting the associated value
 */
internal extension EVAssociated {
    /**
     Easy access to the associated value of an enum.
     
     :returns: The label of the enum plus the associated value
     */
    internal var associated: (label:String, value: Any?) {
        get {
            let mirror = Mirror(reflecting: self)
            if let associated = mirror.children.first {
                return (associated.label!, associated.value)
            }
            print("WARNING: Enum option of \(self) does not have an associated value")
            return ("\(self)", nil)
        }
    }
}

/**
 Dictionary extension for creating a dictionary from an array of enum values
 */
internal extension Dictionary {
    /**
     Create a dictionairy based on all associated values of an enum array
     
     - parameter associated: array of dictionairy values which have an associated value
     
     - returns: A dictionairy of all enum values and associated values
     */
    init<T :EVAssociated>(associated: [T]?) {
        self.init()
        if associated != nil {
            for myEnum in associated! {
                self[myEnum.associated.label as! Key] = myEnum.associated.value as? Value
            }
        }
    }
}
