//
//  Data.swift
//  Conway's Game of Life
//
//  Created by Peter Janosky on 11/13/19.
//

import Foundation

class Data: ObservableObject {
    @Published var colonies: [Colony] = [Colony(size: 60, name: "New Colony 1"), Colony(size: 60, name: "New Colony 2"), Colony(size: 60, name: "Template 1", template: true), Colony(size: 60, name: "Template 2", template: true)]
    @Published var currentColony = 0
    
    init() {
        colonies[0].setCellAlive(Cell(10, 2))
        colonies[1].setCellAlive(Cell(10, 10))
        
        colonies[2].setCellAlive(Cell(40, 40))
        colonies[3].setCellAlive(Cell(30, 40))
    }
    
    private static var nextID = 0
    static var nextColonyID: Int {
        nextID += 1
        return nextID
    }
}
