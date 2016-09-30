//
//  NodeBoard.swift
//  Assignment3
//
//  Created by Jørgen Henrichsen on 30/09/16.
//  Copyright © 2016 Jørgen Henrichsen. All rights reserved.
//

import Foundation

// A square board of nodes
class NodeBoard {
    
    var nodes: [Node]
    let height: Int
    let width: Int
    
    init(nodes: [Node]) {
        self.nodes = nodes
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
    
    
}

// A node in the board
struct Node: Equatable, Hashable {
    
    let col: Int
    let row: Int
    let type: NodeType
    
    static func ==(lhs: Node, rhs: Node) -> Bool {
        return lhs.col == rhs.col && lhs.row == rhs.row
    }
    
    var hashValue: Int {
        return col.hashValue + row.hashValue
    }
    
}
