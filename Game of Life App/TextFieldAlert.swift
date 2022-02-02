//
//  TextFieldAlert.swift
//  Game of Life App
//
//  Created by Kiran Mak on 12/6/19.
//  Copyright © 2019 Kiran Mak. All rights reserved.
//

import SwiftUI

struct TextFieldAlert<Presenting>: View where Presenting: View {
    @EnvironmentObject var data: Data
    @Binding var isShowing: Bool
    @Binding var text: String
    var colony: Colony
    let presenting: Presenting

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                self.presenting
                    .disabled(self.isShowing)
                VStack {
                    TextField("Name", text: self.$text)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    Divider()
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                var newTemplate = Colony(name: self.colony.name, size: 60)
                                newTemplate.setColonyFromCells(cells: self.colony.livingCells)
                                self.data.templates.append(newTemplate)
                                self.isShowing.toggle()
                            }
                        }) {
                            Text("Save")
                        }
                        Spacer()
                        Divider()
                        Spacer()
                        Button(action: {
                            withAnimation {
                                self.isShowing.toggle()
                            }
                        }) {
                            Text("Dismiss")
                        }
                        Spacer()
                    }
                }
                .padding()
                .background(Color.white)
                .frame(width: 0.3 * geometry.size.width, height: 0.1 * geometry.size.height)
                .shadow(radius: 1)
                .opacity(self.isShowing ? 1 : 0)
            }
        }
    }

}
/*
struct TextFieldAlert_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldAlert()
    }
}
*/

fileprivate extension View {

    func textFieldAlert(isShowing: Binding<Bool>,
                        text: Binding<String>,
                        colony: Colony) -> some View {
        TextFieldAlert(isShowing: isShowing,
                       text: text,
                       colony: colony,
                       presenting: self)
    }

}
