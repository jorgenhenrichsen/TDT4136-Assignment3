//
//  BoardScene.swift
//  Assignment3
//
//  Created by Tord Åsnes on 26/09/16.
//  Copyright © 2016 Jørgen Henrichsen. All rights reserved.
//

import UIKit
import SpriteKit
class BoardScene: SKScene {
    
    
    override init(size: CGSize) {
        super.init(size: size)
        
        backgroundColor = .lightGray

        
        
    }

    
    func readMap(file: String) {
        do {

            let path = Bundle.main.path(forResource: file, ofType: "txt")
            let text = try String(contentsOfFile: path!)

            print(text)
        } catch {
            print("Could not read file \"\(file)\"")
        }
    }
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
