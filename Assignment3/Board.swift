//
//  Board.swift
//  Assignment3
//
//  Created by Jørgen Henrichsen on 26/09/16.
//  Copyright © 2016 Jørgen Henrichsen. All rights reserved.
//

import Foundation




class Board: NodeBoard, AStarDataSource {
    
    var startNode: Node
    var goalNode: Node

    
    init(nodes: [Node], startNode: Node, goalNode: Node) {
        self.startNode = startNode
        self.goalNode = goalNode
        super.init(nodes: nodes)
    }
    
    
    // Return all adjacent nodes og given node that is walkable.
    func walkableAdjacentNodes(of node: Node) -> [Node] {
        let adjacentN = adjacentNodes(of: node)
        let walkableN = adjacentN.filter({
            return !($0.type == .wall)
        })
        return walkableN
    }
    

    
    func costToMove(from nodeA: Node, to nodeB: Node) -> Int {
        switch nodeB.type {
        case .empty:
            return 1
        case .forest:
            return 10
        case .grass:
            return 5
        case .road:
            return 1
        case .mountain:
            return 50
        case .water:
            return 100
        case .goal, .start:
            return 1
        default:
            print("ERROR: Cost not availabel for node")
            return 0
        }
    }
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
    
    class func createBoard(from textMap: [[Character]]) -> Board? {
        var nodes = [Node]()
        var startNode: Node?
        var goalNode: Node?
        for r in 0..<textMap.count {
            let row = textMap[r]
            for c in 0..<row.count {
                let col = row[c]
                
                let node = Node(col: c, row: r, type: NodeType(rawValue: col)!)
                if node.type == .start {
                    startNode = node
                }
                else if node.type == .goal {
                    goalNode = node
                }
                nodes.append(node)

                
            }
        }
        if let startNode = startNode,
            let goalNode = goalNode {
            let board = Board(nodes: nodes, startNode: startNode, goalNode: goalNode)
            return board
        }
        return nil
    }
    
}
