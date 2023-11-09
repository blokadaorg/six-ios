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

struct ShieldsView: View {
    @ObservedObject var vm = ViewModels.packs
    @ObservedObject var tabVM = ViewModels.tab

    var body: some View {
        List {
            Text("Activate shields to block access to selected content on your supervised devices.")
            .font(.subheadline)
            .foregroundColor(.secondary)
            .listRowSeparator(.hidden)
            .padding([.leading, .trailing, .bottom])
            
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
