//
//  RushHourBoard.swift
//  Assignment3
//
//  Created by Jørgen Henrichsen on 30/09/16.
//  Copyright © 2016 Jørgen Henrichsen. All rights reserved.
//

import Foundation

struct RushHourBoard {
    var nodes: [Node]
    var vehicles: [Vehicle]
    
    let width = 6
    let height = 6
    
    
    func nodeAt(col: Int, row: Int) -> Node? {
        //print("RECEIVED: col:\(col) row:\(row)")
        if (col >= 0 && col < width) && (row >= 0 && row < height) {
            let index = width * row + col
            if index > nodes.count { return nil }
            //  print("OUT: \(nodes[index])")
            return nodes[index]
        }
        return nil
    }
    
    func move(vehicle: Vehicle, in direction: MoveDirection) {
        
    }
    
    
        
    
}

enum MoveDirection {
    case
    left,
    right,
    up,
    down
}

struct Vehicle {
    
    var nodes: [Node]
    let orientation: VehicleOrientation
    var place: Int // Row or col for horizontal and vertical vehicles respectively.
    var length: Int {
        return nodes.count
    }
    
    mutating func moveUp() {
        if orientation == .horizontal {
            
        }
        else {
            
        }
    }
    
    func moveDown() {
        if orientation == .horizontal {
            
        }
        else {
            
        }
    }
    
}

enum VehicleOrientation {
    case
    horizontal,
    vertical
}

