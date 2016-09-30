//
//  FileReader.swift
//  Assignment3
//
//  Created by Tord Åsnes on 26/09/16.
//  Copyright © 2016 Jørgen Henrichsen. All rights reserved.
//

import Foundation


class FileReader: NSObject {
    
    class func readCharacterMap(file: String) -> [[Character]] {
        var map  = [[Character]]()
        
        if let mapString = FileReader.readFile(file: file) {
            let scentences = mapString.components(separatedBy: "\n")
            
            for sentence in scentences {
                var line = [Character]()
                for char in sentence.characters {
                    line.append(char)
                }
                
                if line.count > 0 {
                    map.append(line)
                }
            }
        }
        return map
    }
    
    class func readIntMap(file: String) -> [[Int]] {
        var map = [[Int]]()
        
        if let mapString = FileReader.readFile(file: file) {
            let lines = mapString.components(separatedBy: "\n")
            for line in lines {
                let line = line.components(separatedBy: ",")
                if line.count > 1 {
                    map.append(line.map({string in Int(string)!}))
                }
            }
        }
        
        return map
    }
    
    class func readFile(file: String) -> String? {
        do {
            let path = Bundle.main.path(forResource: file, ofType: "txt")
            let text = try String(contentsOfFile: path!)
            return text
        }
        catch {
            print("No file found")
            return nil
        }
    }
}


