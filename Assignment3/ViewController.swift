//
//  ViewController.swift
//  Assignment3
//
//  Created by Jørgen Henrichsen on 26/09/16.
//  Copyright © 2016 Jørgen Henrichsen. All rights reserved.
//

import UIKit
import SpriteKit
class ViewController: UIViewController {

    
    var board :BoardScene! = nil
    var viewSK: SKView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
        let map = FileReader.readMap(file: "board-1-1")
        
        let board = BoardFactory().createBoard(from: map)!
        
        let pathFinder = PathFinder()
        
        print(board.startNode)
        
        print(board.walkableAdjacentNodes(of: board.startNode))
        
        if let shortestPath = pathFinder.findShortestPathAStar(dataSource: board) {
            print(shortestPath)
        }
        else {
            print("Found no path")
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}








