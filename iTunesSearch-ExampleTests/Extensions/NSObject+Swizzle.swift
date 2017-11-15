//
//  NSObject+Swizzle.swift
//  iTunesSearch-ExampleTests
//
//  Created by William Boles on 14/11/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import Foundation

extension NSObject {
    
    // MARK: - Instance
    
    class func swizzleMethodSelector(_ selector: Selector, withSelector: Selector) {
        let Class = self.self
        swizzleMethodSelector(selector, ofClass: Class, withSelector: withSelector, withClass: Class)
    }
    
    class func swizzleMethodSelector(_ selector: Selector, ofClass: AnyClass, withSelector: Selector, withClass: AnyClass) {
        let original = class_getInstanceMethod(ofClass, selector)
        let swizzled = class_getInstanceMethod(withClass, withSelector)
        method_exchangeImplementations(original!, swizzled!)
    }
    
    // MARK: - Class
    
    class func swizzleClassMethodSelector(_ selector: Selector, withSelector: Selector) {
        let Class = self.self
        swizzleClassMethodSelector(selector, ofClass: Class, withSelector: withSelector, withClass: Class)
    }
    
    class func swizzleClassMethodSelector(_ selector: Selector, ofClass: AnyClass, withSelector: Selector, withClass: AnyClass) {
        let original = class_getClassMethod(ofClass, selector)
        let swizzled = class_getClassMethod(withClass, withSelector)
        method_exchangeImplementations(original!, swizzled!)
    }
}
