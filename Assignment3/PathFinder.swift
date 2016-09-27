//
//  PathFinder.swift
//  Assignment3
//
//  Created by Jørgen Henrichsen on 26/09/16.
//  Copyright © 2016 Jørgen Henrichsen. All rights reserved.
//

import Foundation

protocol AStarDataSource {
    func adjacentNodes(of node: Node) -> [Node]
    func walkableAdjacentNodes(of node: Node) -> [Node]
    func costToMove(from nodeA: Node, to nodeB: Node) -> Int
    var startNode: Node {get}
    var goalNode: Node {get}
}

class PathFinder {
    
    
    
    
    
    
    // Find the shortest path in a board.
    func findShortestPathAStar(dataSource: AStarDataSource) -> [Node]? {
        var closedSteps = Set<Step>()
        var openSteps = [Step(node: dataSource.startNode)]
        
        while !openSteps.isEmpty {
            print("WALKING")
            // remove the lowest F cost step from the open list and add it to the closed list
            // Because the list is ordered, the first step is always the one with the lowest F cost
            let currentStep = openSteps.remove(at: 0)
            closedSteps.insert(currentStep)
            
            // If the currentStep is the goal, convert the steps to a path.
            if currentStep.node == dataSource.goalNode {
                print("FOUND A PATH")
                return convertToPath(lastStep: currentStep)
            }
            
            // Get the adjacent tiles coords of the current step
            let adjacentNodes = dataSource.walkableAdjacentNodes(of: currentStep.node)
            for node in adjacentNodes {
                let step = Step(node: node)
                
                // check if the step isn't already in the closed list
                if closedSteps.contains(step) {
                    continue // ignore it
                }
                
                // Compute the cost from the current step to that step
                let moveCost = dataSource.costToMove(from: currentStep.node, to: step.node)
                
                // Check if the step is already in the open list
                
                if let index = openSteps.index(of: step) {
                    // already in the open list
                    
                    // retrieve the old one (which has its scores already computed)
                    let step = openSteps[index]
                    
                    // check to see if the G score for that step is lower if we use the current step to get there
                    if currentStep.gScore + moveCost < step.gScore {
                        // replace the step's existing parent with the current step
                        step.setParent(predecessor: currentStep, withMoveCost: moveCost)
                        
                        // Because the G score has changed, the F score may have changed too
                        // So to keep the open list ordered we have to remove the step, and re-insert it with
                        // the insert function which is preserving the list ordered by F score
                        openSteps.remove(at: index)
                        openSteps.append(step)
                        openSteps.sort()
                    }
                    
                } else { // not in the open list, so add it
                    // Set the current step as the parent
                    step.setParent(predecessor: currentStep, withMoveCost: moveCost)
                    
                    // Compute the H score which is the estimated movement cost to move from that step to the desired tile coordinate
                    step.hScore = hScoreForNode(current: step.node, goal: dataSource.goalNode)
                    
                    // Add it with the function which preserves the list ordered by F score
                    openSteps.append(step)
                    openSteps.sort()
                }
            }
            
        }
        
        // no path found
        return nil

        
        /*let startStep = Step(node: board.startNode)
        startStep.hScore = hScoreForNode(current: startStep.node, goal: board.goalNode)
        
        var closedList = [Step]()
        var openList = [Step(node: board.startNode)]
        
        while !openList.isEmpty {
            openList.sort() // Sorting by F score.
            let currentStep = openList.remove(at: 0)
            closedList.append(currentStep)
            
            if currentStep.node == board.goalNode {
                // Found sol
            }
            
            let adjacentNodes = board.adjacentNodes(of: currentStep.node)
 
        }
        
 
        return nil*/
    }
    
    
    /*
     The cat will find the shortest path by repeating the following steps:
     Get the square on the open list which has the lowest score. Let’s call this square S.
     Remove S from the open list and add S to the closed list.
     For each square T in S’s walkable adjacent tiles:
     If T is in the closed list: Ignore it.
     If T is not in the open list: Add it and compute its score.
     If T is already in the open list: Check if the F score is lower when we use the current generated path to get there. If it is, update its score and update its parent as well.
    */
    
    
    
    // MARK: - Utility
    
    func hScoreForNode(current: Node, goal: Node) -> Int {
        return abs(current.col - goal.col) + abs(current.row - goal.row)
    }
    
    
    // Backtrace throug the steps and create an array of the nodes in the path.
    func convertToPath(lastStep step: Step) -> [Node] {
        var shortestPath = [Node]()
        var currentStep = step
        while let predecessor = currentStep.predecessor {
            shortestPath.insert(currentStep.node, at: 0)
            currentStep = predecessor
        }
        return shortestPath
    }
    
    
}

class Step: Hashable, Comparable {
    var predecessor: Step?
    let node: Node
    
    var hScore: Int = 0
    var gScore: Int = 0
    
    var score: Int {
        return hScore + gScore
    }
    
    var hashValue: Int {
        return node.col.hashValue + node.row.hashValue
    }
    
    init(node: Node, predecessor: Step? = nil) {
        self.node = node
        self.predecessor = predecessor
    }
    
    static func ==(lhs: Step, rhs: Step) -> Bool {
        return lhs.score == rhs.score
    }
    
    func setParent(predecessor: Step, withMoveCost moveCost: Int) {
        // The G score is equal to the parent G score + the cost to move from the parent to it
        self.predecessor = predecessor
        self.gScore = predecessor.gScore + moveCost
    }
    
    public static func <(lhs: Step, rhs: Step) -> Bool {
        return lhs.score < rhs.score
    }
    

    /*public static func <=(lhs: Step, rhs: Step) -> Bool

    public static func >=(lhs: Step, rhs: Step) -> Bool
    

    public static func >(lhs: Step, rhs: Step) -> Bool*/
}
