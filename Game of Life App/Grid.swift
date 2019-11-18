//
//  Grid.swift
//  Game of Life App
//
//  Created by Kiran Mak on 11/17/19.
//  Copyright © 2019 Kiran Mak. All rights reserved.
//

import SwiftUI

struct Grid: View {
    var calculator: GridCalculator
    var colony: Colony
    let deadCellColor = Color(#colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1))
    let aliveCellColor = Color.accentColor
    let geometry: GeometryProxy
    
    init(colony: Colony, geometry: GeometryProxy) {
        self.colony = colony
        calculator = GridCalculator(colonySize: CGFloat(colony.size))
        self.geometry = geometry
    }
        
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<self.colony.size) { row in
                HStack(spacing: 0) {
                    ForEach(0..<self.colony.size) { col in
                        RoundedRectangle(cornerRadius: self.calculator.cellSize(self.geometry) / 4)
                            .frame(width: self.calculator.cellSize(self.geometry), height: self.calculator.cellSize(self.geometry))
                            .foregroundColor(self.colony.isCellAlive(Cell(row, col)) ? self.aliveCellColor : self.deadCellColor)
                            .padding(self.calculator.cellPadding / 2)
                    }
                }
            }
        }
    }
}

/*struct Grid_Previews: PreviewProvider {
    static var previews: some View {
        Grid()
    }
}*/
