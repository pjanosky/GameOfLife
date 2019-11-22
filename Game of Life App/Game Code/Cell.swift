//
//  Cell.swift
//  Conway's Game of Life
//
//  Created by Peter Janosky on 11/12/19.
//

import Foundation

struct Cell: CustomStringConvertible, Hashable, Codable {
    let row: Int
    let col: Int
    
    init(_ row: Int, _ col: Int) {
        self.row = row
        self.col = col
    }
    
    var description: String {
        return "(\(row), \(col))"
    }
    
    static func makeCoors(data: [(row: Int, col: Int)]) -> [Cell] {
        return data.map({Cell($0.row, $0.col)})
    }
}
