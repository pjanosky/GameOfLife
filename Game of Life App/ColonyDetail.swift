//
//  ColonyDetail.swift
//  Conway's Game of Life
//
//  Created by Peter Janosky on 11/16/19.
//

import SwiftUI

struct ColonyDetail: View {
    @Binding var colony: Colony
    
    init(colony: Binding<Colony>) {
        _colony = colony
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                GridView(colony: self.$colony)
                    .padding(.horizontal)
                    .padding(.top)

                Text("Generation \(self.colony.generationNumber),  \(self.colony.numberLivingCells) \(self.colony.numberLivingCells == 1 ? "Cell" : "Cells") Alive")
                ControlsView(colony: self.$colony, width: geometry.size.width)
                    .padding()
            }.navigationBarTitle(Text(self.colony.name), displayMode: .inline)
        }
    }
}

struct ColonyDetail_Previews: PreviewProvider {
    @State static var colony = Data().colonies[0]
    static var previews: some View {
        ColonyDetail(colony: $colony)
    }
}
