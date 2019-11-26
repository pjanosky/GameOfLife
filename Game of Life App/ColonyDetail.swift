//
//  ColonyDetail.swift
//  Conway's Game of Life
//
//  Created by Peter Janosky on 11/16/19.
//

import SwiftUI

struct ColonyDetail: View {
    @ObservedObject var data = Data()
    @Binding var colony: Colony
    @State private var showTemplatesModal = false
    
    init(colony: Binding<Colony>) {
        _colony = colony
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    var copy = Colony(name: "Untitled", size: 60)
                    copy.cells = self.colony.livingCells()
                    self.data.templates.append(copy)
                    print("got here")
                    print(self.data.templates.count)
                }) {
                    Text("Save as template")
                }
                
                Button(action: {
                    self.showTemplatesModal = true
                }) {
                    Text("Select template")
                }.sheet(isPresented: $showTemplatesModal) {
                    TemplatesModal(colony: self.$colony)
                }
            }
            
            TextField("\(self.colony.name)", text: self.$colony.name)
                .font(.title)
                .multilineTextAlignment(.center)
            Text("Generation \(self.colony.generationNumber),  \(self.colony.numberLivingCells) \(self.colony.numberLivingCells == 1 ? "Cell" : "Cells") Alive")
                .font(.headline)
            GridView(colony: self.$colony)
        }
    }
}


struct ColonyDetail_Previews: PreviewProvider {
    @State static var colony = Data().colonies[0]
    static var previews: some View {
        ColonyDetail(colony: $colony)
    }
}
