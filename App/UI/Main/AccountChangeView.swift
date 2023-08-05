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

struct AccountChangeView: View {
    @ObservedObject var vm = ViewModels.account
    @ObservedObject var contentVM = ViewModels.content
    @ObservedObject var homeVM = ViewModels.home
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var appear = false
    
    @State private var accountId: String = ""
    @State private var isShowingScanner = false

    func handleScan(result: Result<ScanResult, ScanError>) {
       self.isShowingScanner = false  // dismiss the scanner view
       
       switch result {
       case .success(let code):
           self.accountId = code.string
       case .failure(let error):
           print("Scanning failed: \(error.localizedDescription)")
       }
   }

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Text("Restore account")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                        .padding([.top, .bottom], 24)

                    HStack(spacing: 0) {
                        Image(systemName: Image.fAccount)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                        .foregroundColor(Color.accentColor)
                        .padding(.trailing)

                        VStack(alignment: .leading) {
                            Text("Account ID")
                            .fontWeight(.medium)
                            Text("In Blokada, you simply use your account ID to log in and share your account with your kids.")
                                .foregroundColor(.secondary)                            }
                        .font(.subheadline)
                        Spacer()
                    }
                    .padding(.bottom, 8)
    
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
                            Text("Enter your existing account ID below, or scan the QR code from the parent device, in order to restore your account.")
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
                        Text(L10n.accountLabelId)
                            .font(.headline)
                        Spacer()
                    }

                    HStack {
                        TextField(L10n.accountIdStatusUnchanged, text: $accountId)
                            .autocapitalization(.none)

                        Button(action: {
                            self.isShowingScanner = true
                        }) {
                            Image(systemName: "qrcode.viewfinder")
                                .resizable()
                                .frame(width: 20, height: 20)
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

                    VStack {
                        Button(action: {
                            if self.accountId.count == 12 {
                                self.contentVM.stage.dismiss()
                                self.vm.restoreAccount(self.accountId) {
                                }
                            }
                        }) {
                            ZStack {
                                ButtonView(enabled: .constant(self.accountId.count == 12), plus: .constant(true))
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
