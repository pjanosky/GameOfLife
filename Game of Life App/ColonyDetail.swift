//
//  ColonyDetail.swift
//  Conway's Game of Life
//
//  Created by Peter Janosky on 11/16/19.
//

import SwiftUI

struct ColonyDetail: View {
    @State var colony = Data().colonies[0]
    var body: some View {
        VStack {
            Text("Generation \(self.colony.generationNumber),  \(self.colony.numberLivingCells) \(self.colony.numberLivingCells == 1 ? "Cell" : "Cells") Alive")
                .font(.headline)
            GridView(colony: self.$colony)
            ControlsView(colony: self.$colony)
                .padding()
        }.navigationBarTitle(Text(self.colony.name))
    }
}

struct ColonyDetail_Previews: PreviewProvider {
    static var previews: some View {
        ColonyDetail()
    }
}
