//
//  Data.swift
//  Conway's Game of Life
//
//  Created by Peter Janosky on 11/13/19.
//

import Foundation

class Data: ObservableObject {
    @Published var colonies: [Colony] = [Colony(size: 60, name: "New Colony1"), Colony(size: 60, name: "New Colony2")]
    @Published var template: [Colony] = []
    
    init() {
        colonies[0].setCellAlive(Cell(10, 2))
        colonies[1].setCellAlive(Cell(10, 10))
    }
    
    private static var nextID = 0
    static var nextColonyID: Int {
        nextID += 1
        return nextID
    }
}
