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

enum SearchMode {
    case
    aStar,
    bfs,
    djiikstra
}

class Step: Hashable, Comparable {
    
    /*
     The class used to represent a step in the board.
     Holds the total score for a step and the parent step.
     */
    
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
        return lhs.node == rhs.node
    }
    
    func setParent(predecessor: Step, withMoveCost moveCost: Int) {
        // The G score is equal to the parent G score + the cost to move from the parent to it
        self.predecessor = predecessor
        self.gScore = predecessor.gScore + moveCost
    }
    
    public static func <(lhs: Step, rhs: Step) -> Bool {
        return lhs.score < rhs.score
    }
    
    
}


class PathFinder {
    
    let workQueue = DispatchQueue(label: "com.pathfinder.work") // The queue to perform work on.
    
    typealias StepHandler = (_ path: [Node], _ closed: [Node], _ open: [Node], _ current: Node) -> Void
    typealias  PathFoundHandler =  (_ path: [Node]?, _ closed: [Node], _ open: [Node]) -> Void
    
    
    /**
     Finds the shortest path given the datasource provided.
     All work is done on a seperate work queue.
     
     -parameter dataSource: Needs to be a class or struct conforming to the `AStarDataSource` protocol.
     -parameter mode: The searchmode used. Supports AStar, Djiikstra and BFS.
     -parameter delay: In seconds. If supplied the algorithm will delay each iteration with the given value.
     -parameter stepHandler: If supplied, the block will be called each time the algorith does an iteration.
     -parameter pathFoundHandler: Called when a path is found.
     
     */
    func findShortestPath(dataSource: AStarDataSource, mode: SearchMode, delay: Double?, stepHandler: StepHandler?, pathFoundHandler: @escaping PathFoundHandler) {
        

        
        workQueue.async {
            var closedSteps = Set<Step>() // The set of closed steps.
            var openSteps = [Step(node: dataSource.startNode)] // The open steps. The startnode is added as the initial step.
            
            // Local function that converts status and calls the stepHandler on the MainQueue.
            func report(currentStep: Step, closed: Set<Step>, open: [Step]) {
                // Only do work of the stephandler exists.
                if stepHandler != nil {
                    let status = self.convertStatus(lastStep: currentStep, closed: closed, open: open)
                    DispatchQueue.main.async {
                        stepHandler?(status.path, status.closed, status.open, currentStep.node)
                    }
                }
            }
            
            // Local function that does the searching.
            func iterate() {
                
                // Removing the first step from open steps and add to the closed set.
                let currentStep = openSteps.remove(at: 0)
                closedSteps.insert(currentStep)
                
                // Report current status
                report(currentStep: currentStep, closed: closedSteps, open: openSteps)
                
                
                // If the currentStep is the goal, convert status and call the pathfoundHandler.
                if currentStep.node == dataSource.goalNode {
                    print("FOUND A PATH")
                    let path = self.convertToPath(lastStep: currentStep)
                    let closed = self.convertToNodes(stepSet: closedSteps)
                    let open = self.convertToNodes(steps: openSteps)
                    DispatchQueue.main.async {
                        pathFoundHandler(path, closed, open)
                    }
                    return
                }
                
                
                
                // Get the adjacent nodes of the current step's node.
                let adjacentNodes = dataSource.walkableAdjacentNodes(of: currentStep.node)
                for node in adjacentNodes {
                    let step = Step(node: node)
                    
                    // Check that the step isn't already in the closed list.
                    if closedSteps.contains(step) {
                        continue // If it is: ignore it.
                    }
                    
                    // Compute the cost from the current step to that step
                    let moveCost = dataSource.costToMove(from: currentStep.node, to: step.node)
                    
                    // Find the step in the opensteps list.
                    if let index = openSteps.index(of: step) {
                        let step = openSteps[index] // Then get the step at that index.
                        
                        // Check if it is cheaper to go via this step.
                        if currentStep.gScore + moveCost < step.gScore {
                            // replace the step's existing parent with the current step
                            step.setParent(predecessor: currentStep, withMoveCost: moveCost)
                            
                            // If AStart is used, sort the open list by the total F Score.
                            if mode == .aStar {
                                openSteps.sort(by: { step1, step2 in
                                    step1.score <= step2.score
                                })
                            }
                            // If Djiikstra is used, sort the open list by the G Score.
                            else if mode == .djiikstra {
                                openSteps.sort(by: { step1, step2 in
                                    step1.gScore <= step2.gScore
                                })
                            }
                            
                            // Otherwise, we know BFS is used and the open list should be treated as a queue and not sorted.
                            
                        }
                    }
                    // If the step is not in the openSteps list, then calculate the hScore and put it in the open steps list.
                    // Again, we sort the open steps if AStar or Djiisktra is used.
                    else {
                        step.hScore = self.hScoreForNode(current: step.node, goal: dataSource.goalNode)
                        step.setParent(predecessor: currentStep, withMoveCost: moveCost)
                        
                        openSteps.append(step)
                        
                        if mode == .aStar {
                            openSteps.sort(by: { step1, step2 in
                                step1.score <= step2.score
                            })
                        }
                        else if mode == .djiikstra {
                            openSteps.sort(by: { step1, step2 in
                                step1.gScore <= step2.gScore
                            })
                        }
                        
                    }
                }
                if !openSteps.isEmpty {
                    // If a delay is given, wait the time then call iterate again.
                    if let delay = delay {
                        self.workQueue.asyncAfter(deadline: DispatchTime.now() + delay, execute: {
                            iterate()
                        })
                    }
                    // If not, just call iterate again.
                    else {
                        self.workQueue.async {
                            iterate()
                        }
                    }
                }
            }
            iterate() // Call iterate to start the search.
            return
        }
    }
    
    
    // MARK: - Utility
    
    // Calculates the hScore using the manhattan formula.
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
    
    func convertToNodes(steps: [Step]) ->  [Node] {
        return steps.map({$0.node})
    }
    
    func convertToNodes(stepSet: Set<Step>) -> [Node] {
        return stepSet.map({$0.node})
    }
    
    func convertStatus(lastStep: Step, closed: Set<Step>, open: [Step]) -> (path: [Node], closed: [Node], open: [Node]) {
        let path = convertToPath(lastStep: lastStep)
        let closedNodes = convertToNodes(stepSet: closed)
        let openNodes = convertToNodes(steps: open)
        return (path, closedNodes, openNodes)
    }
    
    
    
    
}




