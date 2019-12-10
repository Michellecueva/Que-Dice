//
//  myQueue.swift
//  Que Dice
//
//  Created by Michelle Cueva on 11/24/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import Foundation

struct Queue{
    
    var items:[String] = []
    
    mutating func enqueue(element: String)
    {
        items.append(element)
    }
    
    mutating func dequeue() -> String?
    {
        
        if items.isEmpty {
            return nil
        }
        else{
            let tempElement = items.first
            items.remove(at: 0)
            return tempElement
        }
    }
    
}
