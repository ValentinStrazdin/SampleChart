//
//  ResponseItems.swift
//  SampleChart
//
//  Created by Strazdin, Valentin on 31.10.2019.
//  Copyright © 2019 Strazdin, Valentin. All rights reserved.
//

import Foundation

class ResponseItems<T: Decodable>: Decodable {
    let items: Array<T>
    
    private enum CodingKeys: String, CodingKey {
        case items = "items"
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = (try? container.decode(Array<T>.self, forKey: .items)) ?? []
    }
}
