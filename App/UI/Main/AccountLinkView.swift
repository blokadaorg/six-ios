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
import CoreImage.CIFilterBuiltins

struct AccountLinkView: View {
    @ObservedObject var vm = ViewModels.account
    @ObservedObject var contentVM = ViewModels.content
    @ObservedObject var homeVM = ViewModels.home

    @Environment(\.colorScheme) var colorScheme

    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()

    @State var appear = false
    
    @State private var accountId: String = ""

    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Text("Link account")
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
                            Text("Scan this QR code")
                            .fontWeight(.medium)
                            Text("Link your account ID by scanning the QR code using your child's device.")
                                .foregroundColor(.secondary)
                        }
                        .font(.subheadline)
                        Spacer()
                    }
                    .padding(.bottom, 40)

                    ZStack {
                        VStack {
                            Image(uiImage: generateQRCode(from: self.vm.id))
                                .interpolation(.none)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
    
                            Text(self.accountId)
                                .font(.subheadline)
                                .foregroundColor(Color.secondary)
                                .opacity(self.accountId == "" ? 0.0 : 1.0)
                                .animation(.easeIn, value: self.accountId)
                        }
                        .padding()
                        .opacity(self.accountId == "" ? 0.0 : 1.0)
                        .animation(.easeIn, value: self.accountId)
                        .onTapGesture {
                            if self.accountId != "" {
                                self.vm.copyAccountIdToClipboard()
                            }
                        }
                        .contextMenu {
                            Button(action: {
                                if self.accountId != "" {
                                    self.vm.copyAccountIdToClipboard()
                                }
                            }) {
                                Text(L10n.universalActionCopy)
                                Image(systemName: Image.fCopy)
                            }
                        }

                        Text("Tap to show")
                        .padding()
                        .padding([.top, .bottom], 40)
                        .foregroundColor(Color.cActivePlus)
                        .background(Color.cBackground)
                        .opacity(self.accountId == "" ? 1.0 : 0.0)
                        .onTapGesture {
                            self.vm.authenticate { id in
                                self.accountId = id
                            }
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 2)
                            .foregroundColor(Color.cSecondaryBackground)
                    )
    
                    Spacer()

                    VStack {
                        Button(action: {
                            self.contentVM.stage.dismiss()
                        }) {
                            ZStack {
                                ButtonView(enabled: .constant(true), plus: .constant(true))
                                    .frame(height: 44)
                                Text(L10n.universalActionClose)
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

struct AccountLinkView_Previews: PreviewProvider {
    static var previews: some View {
        AccountLinkView()
    }
}
