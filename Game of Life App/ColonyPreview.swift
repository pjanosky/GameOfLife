//
//  ColonyPreview.swift
//  Game of Life App
//
//  Created by Kiran Mak on 11/17/19.
//  Copyright © 2019 Kiran Mak. All rights reserved.
//

import SwiftUI

struct ColonyPreview: View {
    var colony: Colony
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(colony.name)").font(.headline)
                .font(.headline)
            Text("Generation \(self.colony.generationNumber),  \(self.colony.numberLivingCells) \(self.colony.numberLivingCells == 1 ? "Cell" : "Cells") Alive")
//            GeometryReader { geometry in
//                Grid(colony: self.colony, geometry: geometry, cellPadding: 0.5)
//            }.frame(height: 250)
        }.padding(.leading, 10).padding(.trailing, 10)
    }
}

struct ColonyPreview_Previews: PreviewProvider {
    static var previews: some View {
        ColonyPreview(colony: Data().colonies[0])
    }
}
