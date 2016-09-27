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

    
    var scene :BoardScene! = nil
    var viewSK: SKView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        viewSK = SKView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        view.addSubview(viewSK)
        scene = BoardScene(size: CGSize(width: view.bounds.width, height: view.bounds.height))
        viewSK.presentScene(scene)
        
        let map = FileReader.readMap(file: "board-2-4")
        let board = BoardFactory.createBoard(from: map)
        scene.drawBoard(board: board!)
        
        let pathFinder = PathFinder()
        
        if let shortestPath = pathFinder.findShortestPathAStar(dataSource: board!) {
            
            print(shortestPath)
            scene.drawPath(path: shortestPath)
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








