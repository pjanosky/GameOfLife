//
//  ColonyList.swift
//  Game of Life App
//
//  Created by Kiran Mak on 11/17/19.
//  Copyright © 2019 Kiran Mak. All rights reserved.
//

import SwiftUI

struct ColonyList: View {
    @ObservedObject var data: Data
    @State private var colonyType: ColonyType = .colony
    @State private var colonySelected = false
    @State private var showTemplatesModal = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    Picker(selection: self.$colonyType, label: Text("Type")) {
                        ForEach(ColonyType.allCases) { type in
                            Text(String(describing: type)).tag(type)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    if self.colonyType == .colony {
                        List {
                            ForEach(0..<self.data.colonies.count, id: \.self) { index in
                                NavigationLink(destination: ColonyDetail(colony: self.$data.colonies[index])
                                    .onAppear {
                                        self.colonySelected = true
                                        self.data.currentColony = index
                                    }
                                ) {ColonyPreview(colony: self.data.colonies[index])}
                            }
                        }
                    }
                    else {
                        List {
                            ForEach(0..<self.data.templates.count, id: \.self) { index in
                                NavigationLink(destination: ColonyDetail(colony: self.$data.colonies[self.data.currentColony])
                                    .onAppear {
                                        self.data.colonies[self.data.currentColony].cells = self.data.templates[index].livingCells()
                                    }
                                ) {ColonyPreview(colony: self.data.templates[index])}
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Menu")
            
            .navigationBarItems(trailing:
                Button(action: {
                    self.data.colonies.append(Colony(name: "Untitled", size: 60))
                    self.data.currentColony = self.data.colonies.count - 1
                    self.showTemplatesModal = true
                }
                ) {
                    Text("+").font(.largeTitle)
                }.sheet(isPresented: $showTemplatesModal) {
                    TemplatesModal(colony: self.$data.colonies[self.data.currentColony])
                }
             )
           ColonyDetail(colony: self.$data.colonies[self.data.currentColony])
        }
    }
}


struct ColonyList_Previews: PreviewProvider {
    static var data = Data()
    init() {
        if let loadedData = Data.load(fromFile: "data") {
            ColonyList_Previews.data = loadedData
        }
    }
    
    static var previews: some View {
        ColonyList(data: ColonyList_Previews.data)
    }
}

