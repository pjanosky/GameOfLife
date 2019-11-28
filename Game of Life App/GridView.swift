//
//  GridView.swift
//  Conway's Game of Life
//
//  Created by Peter Janosky on 11/13/19.
//

import SwiftUI

struct GridView: View {
    @Binding var colony: Colony
    
    var body: some View {
        GeometryReader { geometry in
            self.grid(geometry: geometry)
        }
    }
    
    func grid(geometry: GeometryProxy) -> some View {
        let calculator = GridCalculator(colonySize: self.colony.size, cellPadding: 2, geometry: geometry)
        return Grid(colony: self.$colony, calculator: calculator, geometry: geometry)
    }
}

struct GridCalculator {
    let cellPadding: CGFloat
    let colonySize: CGFloat
    let cellSize: CGFloat
    let geometry: GeometryProxy
    let size: CGFloat
    
    init(colonySize: Int, cellPadding: CGFloat, geometry: GeometryProxy) {
        self.cellPadding = cellPadding
        self.geometry = geometry
        self.colonySize = CGFloat(colonySize)
        
        self.size = min(geometry.size.height, geometry.size.width)
        let gridSize = size - cellPadding * (self.colonySize - 1)
        self.cellSize = gridSize / self.colonySize
    }
    
    func getCellFrom(location: CGPoint) -> Cell {
        let row = location.y / (cellSize + cellPadding)
        let col = location.x / (cellSize + cellPadding)
        return Cell(Int(row), Int(col))
    }
}

struct GridView_Previews: PreviewProvider {
    @State static var colony = Data().colonies[0]
    static var previews: some View {
        GridView(colony: $colony)
    }
}
