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
            Text("\(colony.name)")
                .font(.headline)
            Text("Generation \(self.colony.generationNumber),  \(self.colony.numberLivingCells) \(self.colony.numberLivingCells == 1 ? "Cell" : "Cells") Alive")
        }.padding(5)
    }
}

struct ColonyPreview_Previews: PreviewProvider {
    static var previews: some View {
        ColonyPreview(colony: Data().colonies[0])
    }
}
