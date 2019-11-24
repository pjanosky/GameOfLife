//
//  Colony.swift
//  Conway's Game of Life
//
//  Created by Peter Janosky on 11/12/19.
//

import Foundation
import SwiftUI

struct Colony: CustomStringConvertible, Identifiable, Codable {
    var name: String
    private (set) var size: Int

    private (set) var generationNumber = 0
    private (set) var cells: Set<Cell> = Set<Cell>()
    private var wrapping = true
    var id = Data.nextColonyID

    private static let offsets: [(row: Int, col: Int)] = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]
    
    init(name: String, size: Int) {
        self.name = name
        self.size = size
    }
    

    mutating func setColonyFromCells(cells: Set<Cell>) {
        clear()
        self.cells = cells
    }

    mutating func clear() {
        cells = Set<Cell>()
        generationNumber = 0
    }

    mutating func setCellAlive(_ cell: Cell) {
        if isGoodCell(cell) {
            cells.insert(cell)
        }
    }

    mutating func setCellDead(_ cell: Cell) {
        if isGoodCell(cell) {
            cells.remove(cell)
        }
    }

    mutating func toggleCell(_ cell: Cell) {
        if isCellAlive(cell) {
            setCellDead(cell)
        } else {
            setCellAlive(cell)
        }
    }

    func isCellAlive(_ cell: Cell) -> Bool {
        return cells.contains(cell)
    }

    var numberLivingCells: Int {
        return cells.count
    }

    func livingCells() -> Set<Cell> {
        return cells
    }

    func w(_ n: Int) -> Int {
        return (n + size) % size
    }

    func isGoodCell(_ cell: Cell) -> Bool {
        return (cell.row >= 0) && (cell.row < size) && (cell.col >= 0) && (cell.col < size)
    }

    func cellsToCheck(cell: Cell) -> Set<Cell> {
        var result = Set<Cell>()
        for offset in Self.offsets {
            let offsetCoordinate = Cell(cell.row + offset.row, cell.col + offset.col)
            if isGoodCell(offsetCoordinate) {
                result.insert(offsetCoordinate)
            }
        }
        return result
    }

    func cellsToCheckWrap(cell: Cell) -> Set<Cell> {
        var result = Set<Cell>()
        for offset in Self.offsets {
            result.insert(Cell(w(cell.row + offset.row), w(cell.col + offset.col)))
        }
        return result
    }

    func countNeighbors(cell: Cell) -> Int {
        var count = 0
        let neighbors = wrapping ? cellsToCheckWrap(cell: cell) : cellsToCheck(cell: cell)
        for cell in neighbors {
            if cells.contains(cell) {
                count += 1
            }
        }
        return count
    }

    func cellSurvives(cell: Cell) -> Bool {
        let livingNeighbors = countNeighbors(cell: cell)
        if livingNeighbors == 3 {return true}
        if livingNeighbors < 2 || livingNeighbors > 3 {return false}
        return isCellAlive(cell)
    }

    mutating func evolve() {
        wrapping = false
        var newCells = Set<Cell>()
        cells.forEach{newCells.formUnion(cellsToCheck(cell: $0))}
        cells = newCells.filter {cellSurvives(cell: $0)}
        generationNumber += 1
    }

    mutating func evolveWrap() {
        wrapping = true
        var newCells = Set<Cell>()
        cells.forEach{newCells.formUnion(cellsToCheckWrap(cell: $0))}
        cells = newCells.filter {cellSurvives(cell: $0)}
        generationNumber += 1
    }

    var description: String {
        var result = ""
        for r in 0..<size {
            for c in 0..<size {
                result += isCellAlive(Cell(r, c)) ? "* " : ". "
            }
            result += "\n"
        }
        return "generation #\(generationNumber)\n\(result)"
    }
}

enum ColonyType: Int, CaseIterable, Identifiable, Equatable, CustomStringConvertible {
    case colony, template
    
    var id: Int { self.rawValue }
    
    var description: String {
        switch self {
        case .colony: return "Colonies"
        case .template: return "Templates"
        }
    }
}
