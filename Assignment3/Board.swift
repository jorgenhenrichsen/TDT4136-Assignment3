//
//  Board.swift
//  Assignment3
//
//  Created by Jørgen Henrichsen on 26/09/16.
//  Copyright © 2016 Jørgen Henrichsen. All rights reserved.
//

import Foundation

class Board: AStarDataSource {
    
    var nodes: [Node]
    var startNode: Node
    var goalNode: Node
    var height: Int
    var width: Int
    
    init(nodes: [Node], startNode: Node, goalNode: Node) {
        self.nodes = nodes
        self.startNode = startNode
        self.goalNode = goalNode
        self.height = nodes.last!.row + 1
        self.width = nodes.last!.col + 1
    }
    

    func nodeNorth(of node: Node) -> Node? {
        let row = node.row - 1
        
        return nodeAt(col: node.col, row: row)
    }
    
    func nodeSouth(of node: Node) -> Node? {
        let row = node.row + 1
        return nodeAt(col: node.col, row: row)
    }
    
    func nodeWest(of node: Node) -> Node? {
        let col = node.col - 1
        return nodeAt(col: col, row: node.row)
    }
    
    func nodeEast(of node: Node) -> Node? {
        let col = node.col + 1
        return nodeAt(col: col, row: node.row)
    }
    
    // Return all adjacent nodes of given node.
    func adjacentNodes(of node: Node) -> [Node] {
        var aNodes = [Node]()
        if let nNode = nodeNorth(of: node) { aNodes.append(nNode) }
        if let sNode = nodeSouth(of: node) { aNodes.append(sNode) }
        if let wNode = nodeWest(of: node) { aNodes.append(wNode) }
        if let eNode = nodeEast(of: node) { aNodes.append(eNode) }
        return aNodes
    }
    
    // Return all adjacent nodes og given node that is walkable.
    func walkableAdjacentNodes(of node: Node) -> [Node] {
        let adjacentN = adjacentNodes(of: node)
        let walkableN = adjacentN.filter({
            return !($0.type == .wall)
        })
        return walkableN
    }
    
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
    
    func costToMove(from nodeA: Node, to nodeB: Node) -> Int {
        return 1
    }
}

// A node in the board
struct Node: Equatable {
    
    let col: Int
    let row: Int
    let type: NodeType
    
    static func ==(lhs: Node, rhs: Node) -> Bool {
        return lhs.col == rhs.col && lhs.row == rhs.row
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
