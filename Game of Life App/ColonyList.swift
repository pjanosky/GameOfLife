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
    @State var selection: ColonyType = .colony
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    Picker(selection: self.$selection, label: Text("Type")) {
                        ForEach(ColonyType.allCases) { type in
                            Text(String(describing: type)).tag(type)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    if self.selection == .colony {
                        List(0..<self.data.colonies.count) { index in
                            NavigationLink(destination: ColonyDetail(colony: self.$data.colonies[index]).onAppear {
                                self.data.currentColony = index
                            }) {
                                ColonyPreview(colony: self.data.colonies[index])}
                        }
                    } else {
                        List(0..<self.data.templates.count) { index in
                            Button(action: {
                                self.data.templates[self.data.currentColony].setColonyFromCells(cells: self.data.templates[index].cells)
                            }) {
                                ColonyPreview(colony: self.data.templates[index])
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(String(describing: self.selection))
        }
    }
}

struct ColonyList_Previews: PreviewProvider {
    static var previews: some View {
        ColonyList()
    }
}

