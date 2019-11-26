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
    @State var scale: CGFloat = 1.0
    @State var offset: CGSize = .zero
    var calculator: GridCalculator
    
    init(colony: Binding<Colony>, calculator: GridCalculator) {
        _colony = colony
        self.calculator = calculator
    }
        
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<self.colony.size) { row in
                HStack(spacing: 0) {
                    ForEach(0..<self.colony.size) { col in
                        RoundedRectangle(cornerRadius: self.calculator.cellSize / 4)
                            .frame(width: self.calculator.cellSize, height: self.calculator.cellSize)
                            .foregroundColor(self.colony.isCellAlive(Cell(row, col)) ? Color.accentColor : Color("DeadCellColor"))
                            .padding(self.calculator.cellPadding / 2)
                            .highPriorityGesture(TapGesture().onEnded{
                                self.colony.toggleCell(Cell(row, col))
                            })
                    }
                }
            }
        }
        .drawingGroup()
        .gesture(DragGesture(minimumDistance: 0.0)
            .onChanged { value in
                self.dragGestureChanged(value)
            }.onEnded { _ in
                self.startingGesture = true
            }
        ).gesture(MagnificationGesture()
            .onChanged { value in
                self.scale = max(self.scale * value, 1.0)
            }
        ).highPriorityGesture(TapGesture(count: 2).simultaneously(with: DragGesture()
            .onChanged { value in
                self.offset.width += value.translation.width
                self.offset.height += value.translation.height
            }
        ))
        .scaleEffect(self.scale)
        .offset(self.offset)
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
