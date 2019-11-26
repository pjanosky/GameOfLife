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
    @Binding var colony: Colony
    @ObservedObject var data = Data()
    @Environment(\.presentationMode) var presentationMode
    @State private var templateSelected: Colony? = nil
    
    var body: some View {
        var templateArray: [[Colony]] = []
        _ = self.data.templates.publisher
            .collect(2)
            .collect()
            .sink(receiveValue: {templateArray = $0})
        
        return VStack {
            Button(action: {
                self.colony.cells = self.templateSelected!.livingCells()
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Done")
            }.disabled(self.templateSelected == nil)
            
            ForEach(0..<templateArray.count, id: \.self) { row in
                HStack {
                    ForEach(templateArray[row]) { template in
                        Button(action: {
                            self.templateSelected = template
                        }) {
                            ColonyPreview(colony: template)
                        }
                    }
                }
            }
            Spacer()
        }.padding(.leading, 10).padding(.trailing, 10)
    }
}


//struct TemplatesModal_Previews: PreviewProvider {
//    static var previews: some View {
//        TemplatesModal()
//    }
//}
