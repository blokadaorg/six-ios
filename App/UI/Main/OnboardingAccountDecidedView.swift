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

struct OnboardingAccountDecidedView: View {
    @ObservedObject var vm = ViewModels.account
    @ObservedObject var contentVM = ViewModels.content
    @ObservedObject var homeVM = ViewModels.home

    @State var appear = false

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Text("Add device")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                        .padding([.top, .bottom], 24)
                    
                    Button(action: {
                        self.contentVM.stage.showModal(StageModal.accountLink)
                    }) {
                        HStack(spacing: 0) {
                            Image(systemName: "apps.iphone.badge.plus")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 32, height: 32)
                                .foregroundColor(Color.accentColor)
                                .padding(.trailing)
                            
                            VStack(alignment: .leading) {
                                Text("Link a device")
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                                Text("In Blokada, you simply use your account ID to log in and share your account with your kids.")
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.leading)
                            }
                            .font(.subheadline)
                            Spacer()
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(lineWidth: 2)
                                .foregroundColor(Color.cSecondaryBackground)
                        )
                    }
                    .padding(.bottom, 8)
                    
                    Text("- or -")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                    .padding()
                    
                    Button(action: {
                        self.contentVM.stage.setRoute("home/lock")
                    }) {
                        HStack(spacing: 0) {
                            Image(systemName: "lock.iphone")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 32, height: 32)
                                .foregroundColor(Color.accentColor)
                                .padding(.trailing)
                            
                            VStack(alignment: .leading) {
                                Text("Link this device")
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                                
                                Text("Alternatively, you may simply configure Blokada to work on this device, and set the pin to lock the app.")
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.leading)
                            }
                            .font(.subheadline)
                            Spacer()
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(lineWidth: 2)
                                .foregroundColor(Color.cSecondaryBackground)
                        )
                        
                    }

                    Spacer()
                }
                .frame(maxWidth: 500)
                .navigationBarItems(trailing:
                                        Button(action: {
                    self.contentVM.stage.dismiss()
                }) {
                    Text(L10n.universalActionDone)
                }
                    .contentShape(Rectangle())
                )
            }
            .padding([.leading, .trailing], 40)
        }
        .opacity(self.appear ? 1 : 0)
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(Color.cAccent)
        .onAppear {
            self.appear = true
        }
    }
}

struct OnboardingAccountDecidedView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingAccountDecidedView()
    }
}
