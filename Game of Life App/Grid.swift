//
//  Grid.swift
//  Game of Life App
//
//  Created by Kiran Mak on 11/17/19.
//  Copyright © 2019 Kiran Mak. All rights reserved.
//

import SwiftUI

struct Grid: View {
    @Binding var colony: Colony
    @State var settingAlive = true
    @State var startingGesture = true
    var calculator: GridCalculator
    var geometry: GeometryProxy
    
    init(colony: Binding<Colony>, calculator: GridCalculator, geometry: GeometryProxy) {
        _colony = colony
        self.calculator = calculator
        self.geometry = geometry
    }
        
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: self.calculator.cellSize / 3)
                .frame(width: self.calculator.size, height: self.calculator.size)
                .foregroundColor(Color("GridBackgroundColor"))
                .gesture(DragGesture(minimumDistance: 0.0)
                    .onChanged { value in
                        self.dragGestureChanged(value)
                    }.onEnded { _ in
                        self.startingGesture = true
                    }
                )
            
            Path { path in
                let numberGridLines = self.colony.size
                for index in 0..<numberGridLines {
                    let offset: CGFloat = CGFloat(index) * self.calculator.size / CGFloat(numberGridLines)
                    
                    path.move(to: CGPoint(x: 0, y: offset))
                    path.addLine(to: CGPoint(x: self.calculator.size, y: offset))
                    path.move(to: CGPoint(x: offset, y: 0))
                    path.addLine(to: CGPoint(x: offset, y: self.calculator.size))
                }
            }
            .stroke(Color("GridLineColor"), lineWidth: 2)
            
            ForEach(0..<self.colony.size) { row in
                ForEach(0..<self.colony.size) { col in
                    if self.colony.isCellAlive(Cell(row, col)) {
                        RoundedRectangle(cornerRadius: self.calculator.cellSize / 3)
                            .frame(width: self.calculator.cellSize, height: self.calculator.cellSize)
                            .foregroundColor(Color.accentColor)//self.colony.isCellAlive(Cell(row, col)) ? Color.accentColor : Color("DeadCellColor"))
                            .offset(x: CGFloat(col) * (self.calculator.cellSize + self.calculator.cellPadding), y: CGFloat(row) * (self.calculator.cellSize + self.calculator.cellPadding))
                    }
                }
            }
        }
        .frame(width: self.calculator.size, height: self.calculator.size)
        .drawingGroup()
    }

    func dragGestureChanged(_ value: DragGesture.Value) {
        if self.startingGesture {
            let startCell = self.calculator.getCellFrom(location: value.startLocation)
            self.settingAlive = !self.colony.isCellAlive(startCell)
            self.colony.toggleCell(startCell)
            self.startingGesture = false
        }
        
        let cell = self.calculator.getCellFrom(location: value.location)
        if self.settingAlive {
            self.colony.setCellAlive(cell)
        } else {
            self.colony.setCellDead(cell)
        }
    }
    
}

/*struct Grid_Previews: PreviewProvider {
    static var previews: some View {
        Grid()
    }
}*/
