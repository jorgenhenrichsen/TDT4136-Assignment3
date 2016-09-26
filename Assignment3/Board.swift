//
//  Board.swift
//  Assignment3
//
//  Created by Jørgen Henrichsen on 26/09/16.
//  Copyright © 2016 Jørgen Henrichsen. All rights reserved.
//

import Foundation

class Board {
    
    var nodes: [Node]
    
    init(nodes: [Node]) {
        self.nodes = nodes
    }
    
    convenience init(){
        self.init(nodes: [Node]())
    }
    
    
}

struct Node {
    
    let col: Int
    let row: Int
    let type: NodeType
    
    
}

enum NodeType: Character {
    case
    empty = ".",
    wall = "#",
    start = "A",
    goal = "B",
    water  = "w",
    mountain = "m",
    forest = "f",
    grass = "g",
    road = "r"
}

class BoardFactory {
    
    func createBoard(from textMap: [[Character]]) -> Board {
        var nodes = [Node]()
        for r in 0..<textMap.count {
            let row = textMap[r]
            for c in 0..<row.count {
                let col = row[c]
                
                let node = Node(col: c, row: r, type: NodeType(rawValue: col)!)
                nodes.append(node)
                
            }
        }
        
        let board = Board(nodes: nodes)
        return board
    }
    
}
