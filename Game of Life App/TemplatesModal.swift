//
//  TemplatesModal.swift
//  Game of Life App
//
//  Created by Peter Janosky on 11/26/19.
//  Copyright © 2019 Kiran Mak. All rights reserved.
//

import SwiftUI

import SwiftUI
import Combine
 
struct TemplatesModal: View {
    @EnvironmentObject var data: Data
    @Binding var colony: Colony
    @Binding var showing: Bool
    @State var selectedTemplate: Colony?
    
    var body: some View {
        VStack {
            HStack(alignment: .firstTextBaseline) {
                Button(action: {
                    self.showing = false
                }) {
                    Text("Cancel")
                }
                
                Spacer()
                Text("Tempates")
                    .font(.title)
                Spacer()
                
                Button(action: {
                    self.colony.setColonyFromCells(cells: self.selectedTemplate!.livingCells)
                    self.showing = false
                }) {
                    Text("Apply")
                }.disabled(self.selectedTemplate == nil)
            }.padding()
            
            List {
                ForEach(self.data.templates) { template in
                    HStack(spacing: 0) {
                        if self.selectedTemplate != nil && template == self.selectedTemplate! {
                            Image(systemName: "checkmark")
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                        } else {
                            Spacer()
                                .frame(width: 30, height: 30)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("\(template.name)")
                                .font(.headline)
                            Text("\(template.numberLivingCells) Living \(template.numberLivingCells == 1 ? "Cell" : "Cells")")
                        }.padding(5)
                    }
                    .foregroundColor((self.selectedTemplate != nil && template == self.selectedTemplate!) ? .accentColor : .primary)
                    .onTapGesture {
                        self.selectedTemplate = template
                    }
                }.onDelete(perform: self.deleteTemplate)
            }
            
            Divider()
            
            Button(action: {
                var newTempate = Colony(name: self.colony.name, size: 60)
                newTempate.setColonyFromCells(cells: self.colony.livingCells)
                self.data.templates.append(newTempate)
            }) {
                Text("Save Current Colony")
            }.padding()
        }
    }
    
    func deleteTemplate(at offsets: IndexSet) {
        self.data.templates.remove(atOffsets: offsets)
    }
}


//struct TemplatesModal_Previews: PreviewProvider {
//    static var previews: some View {
//        TemplatesModal()
//    }
//}
