//
//  ViewController.swift
//  Assignment3
//
//  Created by Jørgen Henrichsen on 26/09/16.
//  Copyright © 2016 Jørgen Henrichsen. All rights reserved.
//

import UIKit
import SpriteKit
class PathFinderVC: UIViewController, UIScrollViewDelegate {
    
    var scenes = [BoardScene]()
    var skViews = [SKView]()
    
    var scrollView: UIScrollView!
    
    let pathFinder = PathFinder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        scrollView = UIScrollView(frame: view.frame)
        scrollView.delegate = self
        scrollView.backgroundColor = .white
        scrollView.isPagingEnabled = true
        view.addSubview(scrollView)

        let boards = ["board-1-1", "board-1-2", "board-1-3", "board-1-4", "board-2-1", "board-2-2", "board-2-3", "board-2-4"]
        var currentYPosition: CGFloat = 0
        
        for (index, boardName) in boards.enumerated() {
            
            let map = FileReader.readMap(file: boardName)
            let loadedBoard = BoardFactory.createBoard(from: map)
            
            let tileSize = view.bounds.width / CGFloat(loadedBoard!.width)
            let sceneHeight = tileSize * CGFloat(loadedBoard!.height)
            
            let skView = SKView(frame: CGRect(x: 0, y: currentYPosition, width: view.bounds.width, height: sceneHeight))
            scrollView.addSubview(skView)
            
            let scene = BoardScene(size: CGSize(width: view.bounds.width, height: sceneHeight))
            skView.presentScene(scene)
            
            let spacing: CGFloat = view.bounds.height - sceneHeight
            
            let bfsButton = UIButton(frame: CGRect(x: 0, y: currentYPosition + sceneHeight,
                                                   width: view.bounds.width/3, height: view.bounds.height - sceneHeight))
            bfsButton.addTarget(self, action: #selector(drawBFS(sender:)), for: .touchUpInside)
            bfsButton.tag = index * 10 + 1
            bfsButton.setTitle("BFS", for: .normal)
            bfsButton.setTitleColor(.black, for: .normal)
            scrollView.addSubview(bfsButton)
            
            let djiikstraButton = UIButton(frame: CGRect(x: view.bounds.width/3, y: currentYPosition + sceneHeight,
                                                         width: view.bounds.width/3, height: view.bounds.height - sceneHeight))
            djiikstraButton.addTarget(self, action: #selector(drawDjiikstra(sender:)), for: .touchUpInside)
            djiikstraButton.tag = index  * 10 + 2
            djiikstraButton.setTitle("Djiikstra", for: .normal)
            djiikstraButton.setTitleColor(.black, for: .normal)
            scrollView.addSubview(djiikstraButton)
            
            let aStarButton = UIButton(frame: CGRect(x: (view.bounds.width/3) * 2, y: currentYPosition + sceneHeight,
                                                     width: view.bounds.width/3, height: view.bounds.height - sceneHeight))
            aStarButton.addTarget(self, action: #selector(drawAStar(sender:)), for: .touchUpInside)
            aStarButton.tag = index * 10 + 3
            aStarButton.setTitle("A*", for: .normal)
            aStarButton.setTitleColor(.black, for: .normal)
            scrollView.addSubview(aStarButton)

            scene.drawBoard(board: loadedBoard!)
            currentYPosition += (sceneHeight + spacing)
            
            skViews.append(skView)
            scenes.append(scene)

        }
        scrollView.contentSize = CGSize(width: view.bounds.width, height: currentYPosition)

        
        //let paths = pathFinder.findShortestPath(dataSource: board!, mode: .aStar)
        
    }
    
    
    func drawBFS(sender: UIButton) {
        let index = (sender.tag - 1) / 10
        displayAlgorithm(type: .bfs, scene: scenes[index])
        sender.setTitleColor(.black, for: .normal)
        (scrollView.viewWithTag(sender.tag + 1) as! UIButton).setTitleColor(.lightGray, for: .normal)
        (scrollView.viewWithTag(sender.tag + 2) as! UIButton).setTitleColor(.lightGray, for: .normal)

    }
    
    func drawDjiikstra(sender: UIButton) {
        let index = (sender.tag - 2) / 10
        displayAlgorithm(type: .djiikstra, scene: scenes[index])
        sender.setTitleColor(.black, for: .normal)
        (scrollView.viewWithTag(sender.tag - 1) as! UIButton).setTitleColor(.lightGray, for: .normal)
        (scrollView.viewWithTag(sender.tag + 1) as! UIButton).setTitleColor(.lightGray, for: .normal)
    }
    
    func drawAStar(sender: UIButton) {
        let index = (sender.tag - 3) / 10
        displayAlgorithm(type: .aStar, scene: scenes[index])
        sender.setTitleColor(.black, for: .normal)
        (scrollView.viewWithTag(sender.tag - 2) as! UIButton).setTitleColor(.lightGray, for: .normal)
        (scrollView.viewWithTag(sender.tag - 1) as! UIButton).setTitleColor(.lightGray, for: .normal)
    }
    
    
    func displayAlgorithm(type: SearchMode, scene: BoardScene) {

        pathFinder.findShortestPath(dataSource: scene.board!, mode: type) { (path, closed, open, current) in
            scene.clearNodes()
            scene.drawPath(path: path)
            let shortestPathSet = Set<Node>(path)
            let closedSet = Set<Node>(closed)
            scene.drawClosedNodes(nodes: Array(closedSet.subtracting(shortestPathSet)))

            scene.drawOpenNodes(nodes: open)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
