//
//  BoardScene.swift
//  Assignment3
//
//  Created by Tord Åsnes on 26/09/16.
//  Copyright © 2016 Jørgen Henrichsen. All rights reserved.
//

import UIKit
import SpriteKit


extension SKSpriteNode {
    convenience init(name: String) {
        let texture = SKTexture(imageNamed: name)
        self.init(texture: texture, size: texture.size())
    }
}

class BoardScene: SKScene {
    
    var board: Board?
    
    var tempNodes = [SKSpriteNode]()
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    func drawBoard(board: Board) {
        
        self.board = board
        let nodes = board.nodes
        for node in nodes {
            
            var tile :SKSpriteNode!
            
            switch node.type {
            case .empty:
                tile = SKSpriteNode(name: "grass")
            case .wall:
                tile = SKSpriteNode(name: "forest")
            case .start:
                tile = SKSpriteNode(name: "start")
            case .goal:
                tile = SKSpriteNode(name: "goal")
            case .forest:
                tile = SKSpriteNode(name: "forest")
            case .grass:
                tile = SKSpriteNode(name: "grass")
            case .mountain:
                tile = SKSpriteNode(name: "mountain")
            case .road:
                tile = SKSpriteNode(name: "road")
            case .water:
                tile = SKSpriteNode(name: "water")
            }
            
            tile = drawNode(tile: tile, node: node)
            
            addChild(tile)
        }
    }
    
    
    func drawPath(path: [Node]) {
        drawTempNodes(nodes: path, image: "path")
    }
    
    func drawOpenNodes(nodes: [Node]) {
        drawTempNodes(nodes: nodes, image: "openNode")
    }

    func drawClosedNodes(nodes: [Node]) {
        drawTempNodes(nodes: nodes, image: "closedNode")
    }
    
    
    func drawTempNodes(nodes: [Node], image: String) {
    
        var mutableNodes = nodes
        if mutableNodes.count > 0 { mutableNodes.removeLast() }
        for node in mutableNodes {
            if node.type == .start { continue }
            let tile = drawNode(tile: SKSpriteNode(name: image), node: node)
            
            tempNodes.append(tile)
            addChild(tile)
        }
    }
    
    
    func drawNode(tile: SKSpriteNode, node: Node) -> SKSpriteNode {
        
        let nodeSize = size.width / CGFloat(board!.width) // How wide can we draw each node
        
        tile.size = CGSize(width: nodeSize, height: nodeSize)
        let xPos = CGFloat(node.col) * nodeSize + nodeSize/2.0
        let yPos = CGFloat((board!.height - 1) - node.row) * nodeSize + nodeSize/2 // Flip rows, scene drawn from bottom left
        tile.position = CGPoint(x: xPos, y: yPos)
        
        return tile
    }
    
    
    
    func clearNodes() {
        removeChildren(in: tempNodes)
        tempNodes = []
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
