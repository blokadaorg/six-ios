//
//  This file is part of Blokada.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  Copyright © 2023 Blocka AB. All rights reserved.
//
//  @author Kar
//

import SwiftUI
import Factory

struct ShieldsView: View {
    @ObservedObject var vm = ViewModels.packs
    @ObservedObject var tabVM = ViewModels.tab

    @Injected(\.stage) private var stage

    var body: some View {
        List {
            Text("Activate shields to block access to selected content on your supervised devices.")
            .font(.subheadline)
            .foregroundColor(.secondary)
            .listRowSeparator(.hidden)
            .padding([.leading, .trailing, .bottom])

            // My shield (custom exceptions)
            ZStack(alignment: .topLeading) {
                // Background
                ZStack {
                    Rectangle()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [Color(UIColor.systemGray5), Color(UIColor.systemGray3)]),
                            startPoint: .bottomTrailing, endPoint: .leading
                        ))
                        .overlay(Color.cPrimaryBackground.blendMode(.color))
                }
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 10, y: 10)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)

                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 8) {

                        Text("Manage your own custom entries to block or allow.")
                            .font(.body)
                            .padding(.bottom, 16)
                            .foregroundColor(.primary)
                    }
                    .padding([.top, .leading, .trailing])

                    VStack {
                        Button(action: {
                            self.stage.showModal(.custom)
                        }) {
                            ZStack {
                                ButtonView(enabled: .constant(true), plus: .constant(true))
                                    .frame(height: 44)
                                Text("Open exceptions")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                        }
                        .padding()
                    }
                    .background(.regularMaterial)
                    .cornerRadius(8, corners: [.bottomLeft, .bottomRight])
                }
            }
            .padding(.bottom, 8)
            .fixedSize(horizontal: false, vertical: true)

            // List of shields
            ForEach(self.vm.packs, id: \.self) { pack in
                ZStack {
                    ShieldCardView(packsVM: self.vm, vm: PackDetailViewModel(packId: pack.id))
                }
                .listRowSeparator(.hidden)
//                .background(
//                    NavigationLink("", value: pack.id).opacity(0)
//                )
            }
        }
        .listStyle(PlainListStyle())
        .alert(isPresented: self.$vm.showError) {
            Alert(title: Text(L10n.alertErrorHeader), message: Text(L10n.errorPackInstall), dismissButton: .default(Text(L10n.universalActionClose)))
        }
    }
}

struct ShieldsView_Previews: PreviewProvider {
    static var previews: some View {
        ShieldsView()
    }
}
