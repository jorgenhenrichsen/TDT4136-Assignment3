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
        
        
        viewSK = SKView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        view.addSubview(viewSK)
        board = BoardScene(size: CGSize(width: view.bounds.width, height: view.bounds.height))
        viewSK.presentScene(board)
        
        print(FileReader.readMap(file: "board-1-1"))
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}








