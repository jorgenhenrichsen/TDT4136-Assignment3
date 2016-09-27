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
    
    override init(size: CGSize) {
        super.init(size: size)

        
        
        backgroundColor = .white
    }
    
    func drawBoard(board: Board) {
        
        self.board = board
        
        let nodes = board.nodes
        let boardWidth = board.width
        let boardHeight = board.height
        
        print("Width: \(boardWidth) Height: \(boardHeight)")
        
        let nodeSize = Int(size.width) / boardWidth // How wide can we draw each node
                
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
            
            tile.size = CGSize(width: nodeSize, height: nodeSize)
            let xPos = node.col * nodeSize + nodeSize/2
            let yPos = ((boardHeight - 1) - node.row) * nodeSize + nodeSize/2 // Flip rows, scene drawn from bottom left
            tile.position = CGPoint(x: xPos, y: yPos)
            
            addChild(tile)
        }
    }
    
    
    func drawPath(path: [Node]) {
        if let board = board {
            var mutablePath = path
            mutablePath.removeLast()
            let nodeSize = Int(size.width) / board.width // How wide can we draw each node
            for node in mutablePath {
                let tile = SKSpriteNode(color: .yellow, size: CGSize(width: nodeSize, height: nodeSize))
                let xPos = node.col * nodeSize + nodeSize/2
                let yPos = ((board.height - 1) - node.row) * nodeSize + nodeSize/2 // Flip rows, scene drawn from bottom left
                
                tile.position = CGPoint(x: xPos, y: yPos)
                addChild(tile)
            }
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
