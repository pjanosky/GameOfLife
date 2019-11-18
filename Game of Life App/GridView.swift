//
//  GridView.swift
//  Conway's Game of Life
//
//  Created by Peter Janosky on 11/13/19.
//

import SwiftUI

//Code's a little ugly, feel free to make any changes

struct GridView: View {
    @Binding var colony: Colony
    var calculator: GridCalculator
    @State var settingAlive = true
    @State var start = true
    
    
    
    init(colony: Binding<Colony>) {
        _colony = colony
        calculator = GridCalculator(colonySize: CGFloat(colony.wrappedValue.size))
    }
    
    var body: some View {
        GeometryReader { geometry in
            Grid(colony: self.colony, geometry: geometry)
            .drawingGroup()
            .gesture(DragGesture(minimumDistance: 0).onChanged{ value in
                if self.start {
                    if let startCell = self.calculator.getCellFrom(location: value.startLocation, geometry: geometry) {
                        self.settingAlive = !self.colony.isCellAlive(startCell)
                        self.colony.toggleCell(startCell)
                    }
                }
                self.start = false
                
                if let cell = self.calculator.getCellFrom(location: value.location, geometry: geometry) {
                    if self.settingAlive {
                        self.colony.setCellAlive(cell)
                    } else {
                        self.colony.setCellDead(cell)
                    }
                }
            }
            .onEnded { _ in
                self.start = true
                }
            )
        }
    }
}

struct GridCalculator {
    let colonySize: CGFloat
    let cellPadding: CGFloat = 2
    
    func cellSize(_ geometry: GeometryProxy) -> CGFloat {
        let screenSize = min(geometry.size.height, geometry.size.width)
        let gridSize = (screenSize - cellPadding * (colonySize - 1))
        return gridSize / colonySize
    }
    
    func getCellFrom(location: CGPoint, geometry: GeometryProxy) -> Cell? {
        let size = cellSize(geometry) + cellPadding
        let row = location.y / size
        let col = location.x / size
        
        if row >= 0 && row < colonySize && col >= 0 && col < colonySize {
            return Cell(Int(row), Int(col))
        }
        return nil
    }
}

struct GridView_Previews: PreviewProvider {
    @State static var colony = Data().colonies[0]
    static var previews: some View {
        GridView(colony: $colony)
    }
}
