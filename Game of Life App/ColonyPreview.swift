//
//  ColonyPreview.swift
//  Game of Life App
//
//  Created by Kiran Mak on 11/17/19.
//  Copyright © 2019 Kiran Mak. All rights reserved.
//

import SwiftUI

struct ColonyPreview: View {
    @Binding var colony: Colony
    
    var body: some View {
        VStack {
            Text("\(colony.name)").font(.headline)
            Text("Generation \(colony.generationNumber)")
            GeometryReader { geometry in
                Grid(colony: self.colony, geometry: geometry)
            }
        }.padding(.leading, 10).padding(.trailing, 10)
    }
}

struct ColonyPreview_Previews: PreviewProvider {
    @State static var colony = Data().colonies[0]
    static var previews: some View {
        ColonyPreview(colony: $colony)
    }
}
