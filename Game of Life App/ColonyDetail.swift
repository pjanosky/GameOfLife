//
//  ColonyDetail.swift
//  Conway's Game of Life
//
//  Created by Peter Janosky on 11/16/19.
//

import SwiftUI

struct ColonyDetail: View {
    @ObservedObject var data: Data
    @Binding var colony: Colony
    @State private var showTemplatesModal = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack() {
                    Spacer().frame(width: 100)
                    Spacer()
                    TextField("\(self.colony.name)", text: self.$colony.name)
                        .font(.title)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    Button(action: {
                        self.showTemplatesModal = true
                    }) {
                        Text("Templates")
                    }.sheet(isPresented: self.$showTemplatesModal) {
                        TemplatesModal(data: self.data, colony: self.$colony, showing: self.$showTemplatesModal)
                    }.frame(width: 100)
                }.padding()
                
                GridView(colony: self.$colony)
                Text("Generation \(self.colony.generationNumber),  \(self.colony.numberLivingCells) \(self.colony.numberLivingCells == 1 ? "Cell" : "Cells") Alive")
                .font(.headline)
                ControlsView(colony: self.$colony, width: geometry.size.width)
                    .padding(.horizontal)
            }
        }
    }
}


struct ColonyDetail_Previews: PreviewProvider {
    @State static var colony = Data().colonies[0]
    static var previews: some View {
        ColonyDetail(data: Data(), colony: $colony)
    }
}
