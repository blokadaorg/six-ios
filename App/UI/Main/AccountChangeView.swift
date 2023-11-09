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
import CodeScanner
import Factory

struct AccountChangeView: View {
    @ObservedObject var vm = ViewModels.account
    @ObservedObject var contentVM = ViewModels.content
    @ObservedObject var homeVM = ViewModels.home
    
    @Environment(\.colorScheme) var colorScheme
    @Injected(\.commands) var commands
    
    @State var appear = false
    
    @State private var token: String = ""
    @State private var isShowingScanner = false

    func handleScan(result: Result<ScanResult, ScanError>) {
       self.isShowingScanner = false  // dismiss the scanner view
       
       switch result {
       case .success(let code):
           self.token = code.string
       case .failure(let error):
           print("Scanning failed: \(error.localizedDescription)")
       }
   }

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Text("Attach device")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                        .padding([.top, .bottom], 24)
    
                    HStack(spacing: 0) {
                        Image(systemName: "qrcode.viewfinder")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                        .foregroundColor(Color.accentColor)
                        .padding(.trailing)

                        VStack(alignment: .leading) {
                            Text("Scan QR code")
                            .fontWeight(.medium)
                            Text("Scan the QR code from the parent device, in order to attach this device.")
                                .foregroundColor(.secondary)
                        }
                        .font(.subheadline)
                        .onTapGesture {
                            self.isShowingScanner = true
                        }
                        Spacer()
                    }
                    .padding(.bottom, 40)

                    HStack {
                        Button(action: {
                            self.isShowingScanner = true
                        }) {
                            ZStack {
                                ButtonView(enabled: .constant(true), plus: .constant(true))
                                    .frame(height: 44)
                                HStack {
                                    Image(systemName: "qrcode.viewfinder")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.white)
                                    Text("Scan")
                                        .foregroundColor(.white)
                                        .bold()
                                }
                            }
                        }
                        .sheet(isPresented: self.$isShowingScanner) {
                            AccountChangeScanView(isShowingScanner: self.$isShowingScanner, handleScan: self.handleScan)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 2)
                            .foregroundColor(Color.cSecondaryBackground)
                    )
                    
                    Spacer()
                    
                    Text(self.token)
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding([.leading, .trailing], 40)
                        .opacity(self.token.isEmpty ? 0.0 : 1.0)

                    Spacer()

                    VStack {
                        Button(action: {
                            if !self.token.isEmpty {
                                self.contentVM.stage.dismiss()
                                self.commands.execute(CommandName.familyLink, self.token)
                            }
                        }) {
                            ZStack {
                                ButtonView(enabled: .constant(!self.token.isEmpty), plus: .constant(true))
                                    .frame(height: 44)
                                Text(L10n.universalActionContinue)
                                    .foregroundColor(.white)
                                    .bold()
                            }
                        }
                    }
                    .padding(.bottom, 40)
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

struct AccountChangeScanView: View {
    
    @Binding var isShowingScanner: Bool
    let handleScan: (Result<ScanResult, ScanError>) -> Void

    var body: some View {
        ZStack {
            CodeScannerView(codeTypes: [.qr], simulatedData: "mockedmocked", completion: self.handleScan)
            .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button(action: {
                        self.isShowingScanner = false
                    }) {
                        ZStack {
                            Text(L10n.universalActionClose)
                                .foregroundColor(.cAccent)
                        }
                        .padding()
                    }
                }
                .background(Color.black.opacity(0.5))

                Spacer()
            }
            
            RoundedRectangle(cornerRadius: 8)
                .stroke(style: StrokeStyle(lineWidth: 2, dash: [10, 5]))
                .foregroundColor(Color.black.opacity(0.5))
                .frame(width: 240, height: 240)
        }
    }
}

struct AccountChangeView_Previews: PreviewProvider {
    static var previews: some View {
        AccountChangeView()
        AccountChangeScanView(isShowingScanner: .constant(true), handleScan: {scan in })
    }
}
