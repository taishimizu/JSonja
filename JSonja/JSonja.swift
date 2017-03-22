//
//  JSonja.swift
//  JSonja
//
//  Created by Tai Shimizu on 3/21/17.
//  Copyright © 2017 Tai Shimizu. All rights reserved.
//

import Foundation

public protocol JSonjaConstructed{
    init?(item: JsonItem?)
}

public enum JSonjaError: Error {
    case missingRequiredValue, missingRequiredObject
}

public struct JsonItem {
    fileprivate let raw: [String: Any]
    
    init?(dict: [String: Any]?){
        guard let dict = dict else { return nil }
        raw = dict
    }
    
    subscript(key: String) -> String? {
        return raw[key] as? String
    }
    
    subscript(key: String) -> Bool? {
        return raw[key] as? Bool
    }
    
    subscript(key: String) -> Int? {
        return raw[key] as? Int
    }
    
    subscript(key: String) -> Double? {
        return raw[key] as? Double
    }
    
    subscript(key: String) -> [String]? {
        return raw[key] as? [String]
    }
    
    subscript(key: String) -> [Int]? {
        return raw[key] as? [Int]
    }
    
    subscript(key: String) -> [Double]? {
        return raw[key] as? [Double]
    }
    
    subscript(key: String) -> [Bool]? {
        return raw[key] as? [Bool]
    }
    
    subscript(key: String) -> [Any]? {
        return raw[key] as? [Any]
    }

    subscript(key: String) -> [JsonItem]? {
        guard let rawItems = raw[key] as? [[String: Any]] else { return nil }
        return rawItems.flatMap {
            (dict: [String: Any]) -> JsonItem? in
            return JsonItem(dict: dict)
        }
    }
    
    subscript(key: String) -> JsonItem? {
        return JsonItem(dict: raw[key] as? [String: Any])
    }

}

postfix operator ~
postfix operator ~!

postfix func ~ <T>(input: T?) -> T?{
    return input
}

postfix func ~ <T: JSonjaConstructed>(input: JsonItem?) -> T?{
    return T(item: input)
}

postfix func ~ <T: JSonjaConstructed>(input: [JsonItem]?) -> [T]?{
    guard let items = input else { return nil }
    return items.flatMap {
        (item: JsonItem) -> T? in
        return T(item: item)
    }
}

postfix func ~! <T>(input: T?) throws -> T {
    guard let input = input
        else { throw JSonjaError.missingRequiredValue }
    return input
}

postfix func ~! <T: JSonjaConstructed>(input: JsonItem?) throws -> T {
    guard let object: T = input~
        else { throw JSonjaError.missingRequiredObject }
    return object
}

postfix func ~! <T>(input: [T]?) throws -> [T]{
    guard let input = input
        else { throw JSonjaError.missingRequiredObject }
    return input
}

