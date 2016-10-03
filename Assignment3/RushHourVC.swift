//
//  RushHourVC.swift
//  Assignment3
//
//  Created by Tord Åsnes on 30/09/16.
//  Copyright © 2016 Jørgen Henrichsen. All rights reserved.
//

import UIKit
import SpriteKit

class RushHourVC: UIViewController, UIScrollViewDelegate {
    
    var scenes = [RushHourScene]()
    var skViews = [SKView]()
    
    var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView = UIScrollView(frame: view.frame)
        scrollView.delegate = self
        scrollView.backgroundColor = .white
        scrollView.isPagingEnabled = true
        view.addSubview(scrollView)
        
        let boards = ["rh-1", "rh-2", "rh-3", "rh-4"]
        
        var currentXPosition: CGFloat = 0
        
        for (index, boardName) in boards.enumerated() {
            
            let board = FileReader.readIntMap(file: boardName)
            
            
            let sceneWidth = view.bounds.width
            
            let skView = SKView(frame: CGRect(x: currentXPosition, y: 0, width: sceneWidth, height: sceneWidth))
            skView.backgroundColor = .gray
            scrollView.addSubview(skView)
            
            currentXPosition += sceneWidth
            
            
            
        }
        
        
        scrollView.contentSize = CGSize(width: currentXPosition, height: view.bounds.height)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
