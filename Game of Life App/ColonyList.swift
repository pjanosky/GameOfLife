//
//  ColonyList.swift
//  Game of Life App
//
//  Created by Kiran Mak on 11/17/19.
//  Copyright © 2019 Kiran Mak. All rights reserved.
//

import SwiftUI

struct ColonyList: View {
    @ObservedObject var data = Data()
    @State var colonyType: ColonyType = .colony
    @State var colonySelected = false
    var selectedColonies : [Colony] {
        data.colonies.filter{$0.type.rawValue == self.colonyType.rawValue}
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                List {
                    Picker(selection: self.$colonyType, label: Text("Type")) {
                        ForEach(ColonyType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }.pickerStyle(SegmentedPickerStyle()).disabled(!self.colonySelected)
                    
                    ForEach(0..<self.data.colonies.count) { index in
                        if self.data.colonies[index].type.rawValue == self.colonyType.rawValue {
                            NavigationLink(destination: ColonyDetail(colony: self.$data.colonies[self.data.currentColony])
                                .onAppear {
                                    self.colonySelected = true
                                    if self.colonyType == .colony {
                                        self.data.currentColony = index
                                    }
                                    if self.colonyType == .template {
                                        self.data.colonies[self.data.currentColony].cells = self.data.colonies[index].livingCells()
                                    }
                            }) {
                                ColonyPreview(colony: self.$data.colonies[index])}
                        }
                    }.frame(height: geometry.size.width)

                }
            }
            .navigationBarTitle("Menu")
        }
    }
}

struct ColonyList_Previews: PreviewProvider {
    static var previews: some View {
        ColonyList()
    }
}


