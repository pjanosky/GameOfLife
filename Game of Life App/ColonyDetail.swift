//
//  ColonyDetail.swift
//  Conway's Game of Life
//
//  Created by Peter Janosky on 11/16/19.
//

import SwiftUI

struct ColonyDetail: View {
    @EnvironmentObject var data: Data
    @Binding var colony: Colony
    @State private var showTemplatesModal = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HStack() {
                    Spacer().frame(width: 100)
                    Spacer()
                    
                    TextField("\(self.colony.name)", text: self.$colony.name)
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    Button(action: {
                        self.showTemplatesModal = true
                    }) {
                        Text("Templates")
                    }.sheet(isPresented: self.$showTemplatesModal) {
                        TemplatesModal(colony: self.$colony, showing: self.$showTemplatesModal)
                            .environmentObject(self.data)
                    }.frame(width: 100)
                }.padding(.horizontal)
                
                Text("Generation \(self.colony.generationNumber),  \(self.colony.numberLivingCells) \(self.colony.numberLivingCells == 1 ? "Cell" : "Cells") Alive")
                    .font(.headline)
                
                GridView(colony: self.$colony).padding(15)
                ControlsView(colony: self.$colony, width: geometry.size.width)
                    .padding(.horizontal)
            }
        }
    }
}


struct ColonyDetail_Previews: PreviewProvider {
    @State static var colony = Data().colonies[0]
    static var previews: some View {
        ColonyDetail(colony: $colony)
    }
}
