//
//  UnwrapError.swift
//  SampleChart
//
//  Created by Strazdin, Valentin on 31.10.2019.
//  Copyright © 2019 Strazdin, Valentin. All rights reserved.
//

import Foundation

public struct UnwrapError<T> : Error, CustomStringConvertible {
    let optional: T?

    public var description: String {
        return "Found nil while unwrapping \(String(describing: optional))!"
    }
}

func unwrap<T>(_ optional: T?) throws -> T {
    if let real = optional {
        return real
    } else {
        throw UnwrapError(optional: optional)
    }
}
