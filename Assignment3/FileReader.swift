//
//  FileReader.swift
//  Assignment3
//
//  Created by Tord Åsnes on 26/09/16.
//  Copyright © 2016 Jørgen Henrichsen. All rights reserved.
//

import Foundation


class FileReader: NSObject {
    
    class func readMap(file: String) -> [[Character]] {
        var map  = [[Character]]()
        do {
            
            let path = Bundle.main.path(forResource: file, ofType: "txt")
            let text = try String(contentsOfFile: path!)
            
            let scentences = text.components(separatedBy: "\n")
            
            for sentence in scentences {
                var line = [Character]()
                for char in sentence.characters {
                    line.append(char)
                }
                
                if line.count > 0 {
                    map.append(line)
                }
            }
            
        } catch {
            print("Could not read file \"\(file)\"")
        }
        
        return map
    }
}


