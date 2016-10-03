//
//  RushHourBoard.swift
//  Assignment3
//
//  Created by Jørgen Henrichsen on 30/09/16.
//  Copyright © 2016 Jørgen Henrichsen. All rights reserved.
//

import Foundation

class RushHourBoard {
    
    var nodes: [ONode]
    var vehicles: [Vehicle]
    
    init(nodes: [ONode]) {
        self.nodes = nodes
        
        
        
        
        
        
    }
    
    
}

class ONode: Equatable, Hashable {
    
    let col: Int
    let row: Int
    var occupied: Bool = false
    
    static func ==(lhs: ONode, rhs: ONode) -> Bool {
        return lhs.col == rhs.col && lhs.row == rhs.row
    }
    
    var hashValue: Int {
        return col.hashValue + row.hashValue
    }
    
}

class Vehicle {
    var nodes: [Node]
}
