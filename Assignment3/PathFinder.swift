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

class PathFinder {
    
    let workQueue = DispatchQueue(label: "com.pathfinder.work")
    
    
    // Find the shortest path in a board.
    func findShortestPath(dataSource: AStarDataSource, mode: SearchMode) -> (path: [Node]?, closed: [Node], open: [Node]) {
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
                let path = convertToPath(lastStep: currentStep)
                let closed = convertToNodes(stepSet: closedSteps)
                let open = convertToNodes(steps: openSteps)
                return (path, closed, open)
            }
            
            // Get the adjacent tiles coords of the current step
            let adjacentNodes = dataSource.walkableAdjacentNodes(of: currentStep.node)
            for node in adjacentNodes {
                print("Walking through adjacent nodes")
                let step = Step(node: node)
                
                // check if the step isn't already in the closed list
                if closedSteps.contains(step) {
                    print("Ignoring adjacent node")
                    continue // ignore it
                }
                
                // Compute the cost from the current step to that step
                print(step.node)
                let moveCost = dataSource.costToMove(from: currentStep.node, to: step.node)
                
                if let index = openSteps.index(of: step) {
                    let step = openSteps[index]
                    
                    
                    if currentStep.gScore + moveCost < step.gScore {
                        // replace the step's existing parent with the current step
                        step.setParent(predecessor: currentStep, withMoveCost: moveCost)
                        // Because the G score has changed, the F score may have changed too
                        // So to keep the open list ordered we have to remove the step, and re-insert it with
                        // the insert function which is preserving the list ordered by F score
                        
                        
                        
                        openSteps.remove(at: index)
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
                else {
                    step.hScore = hScoreForNode(current: step.node, goal: dataSource.goalNode)
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
        }
        
        return (path: nil, closed: convertToNodes(stepSet: closedSteps), open: convertToNodes(steps: openSteps))

    }
    
    func findShortestPath(dataSource: AStarDataSource, mode: SearchMode, stepHandler: @escaping (_ path: [Node], _ closed: [Node], _ open: [Node], _ current: Node) -> Void) {
        workQueue.async {
            
            
            var closedSteps = Set<Step>()
            var openSteps = [Step(node: dataSource.startNode)]
            
            func report(currentStep: Step, closed: Set<Step>, open: [Step]) {
                let path = self.convertToPath(lastStep: currentStep)
                let closedNodes = self.convertToNodes(stepSet: closed)
                let openNodes = self.convertToNodes(steps: open)
                DispatchQueue.main.async {
                    stepHandler(path, closedNodes, openNodes, currentStep.node)
                }
            }
            
            func iterate() {
                print("WALKING")
                // remove the lowest F cost step from the open list and add it to the closed list
                // Because the list is ordered, the first step is always the one with the lowest F cost
                let currentStep = openSteps.remove(at: 0)
                closedSteps.insert(currentStep)
                
                
                report(currentStep: currentStep, closed: closedSteps, open: openSteps)
                
                
                // If the currentStep is the goal, convert the steps to a path.
                if currentStep.node == dataSource.goalNode {
                    print("FOUND A PATH")
                    /*let path = convertToPath(lastStep: currentStep)
                     let closed = convertToNodes(stepSet: closedSteps)
                     let open = convertToNodes(steps: openSteps)*/
                    return
                    //return (path, closed, open)
                }
                
                
                
                // Get the adjacent tiles coords of the current step
                let adjacentNodes = dataSource.walkableAdjacentNodes(of: currentStep.node)
                for node in adjacentNodes {
                    print("Walking through adjacent nodes")
                    let step = Step(node: node)
                    
                    // check if the step isn't already in the closed list
                    if closedSteps.contains(step) {
                        print("Ignoring adjacent node")
                        continue // ignore it
                    }
                    
                    // Compute the cost from the current step to that step
                    print(step.node)
                    let moveCost = dataSource.costToMove(from: currentStep.node, to: step.node)
                    
                    if let index = openSteps.index(of: step) {
                        let step = openSteps[index]
                        
                        
                        if currentStep.gScore + moveCost < step.gScore {
                            // replace the step's existing parent with the current step
                            step.setParent(predecessor: currentStep, withMoveCost: moveCost)
                            // Because the G score has changed, the F score may have changed too
                            // So to keep the open list ordered we have to remove the step, and re-insert it with
                            // the insert function which is preserving the list ordered by F score
                            
                            
                            
                            openSteps.remove(at: index)
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
                    
                    report(currentStep: currentStep, closed: closedSteps, open: openSteps)
                }
            }
            
            
            func main() {
                while !openSteps.isEmpty {
                    self.workQueue.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                        iterate()
                    })
                }
            }
            
            return
        }
    }
    
    
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
    
    func convertToNodes(steps: [Step]) ->  [Node] {
        return steps.map({$0.node})
    }
    
    func convertToNodes(stepSet: Set<Step>) -> [Node] {
        return stepSet.map({$0.node})
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
