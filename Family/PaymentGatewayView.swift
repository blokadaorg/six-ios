//
//  This file is part of Blokada.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  Copyright © 2023 Blocka AB. All rights reserved.
//
//  @author Karol Gusak
//

import SwiftUI

struct PaymentGatewayView: View {

    @ObservedObject var vm = ViewModels.payment
    @ObservedObject var contentVM = ViewModels.content

    @State var showPrivacySheet = false
    @State var showPlusFeaturesSheet = false

    var body: some View {
        return ZStack(alignment: .topTrailing) {
                ZStack {
                    // Main part - payment options and all
                    HStack {
                        Spacer()
                        VStack {
                            VStack {
                                HStack {
                                    Spacer()
                                    Text("BLOKADA")
                                        .fontWeight(.heavy).kerning(2).font(.system(size: 24))
                                        .foregroundColor(Color.white)

                                    Text("FAMILY")
                                        .fontWeight(.heavy).kerning(2).font(.system(size: 24))
                                        .foregroundColor(Color.white)
                                    Spacer()
                                }
                                .padding(.bottom, 2)

                                
                            }
                            .padding(.top, 50)
                            .padding()
                            
                            Spacer()
                            
                            Text("Protect your entire family with one subscription. Manage content your kids can access and monitor their activity.")
                               .multilineTextAlignment(.center)
                               .lineLimit(6)
                               .font(.system(size: 18))
                               .foregroundColor(Color.secondary)
                               .padding(.top, 60)
                               .padding([.leading, .trailing], 24)
                            
                            Spacer()

                            VStack {
                                PaymentListView(vm: vm, showType: "family")
                            }
                            .padding()
                            
                            Spacer()

                            Button(action: {
                                withAnimation {
                                    self.vm.restoreTransactions()
                                }
                            }) {
                                Text(L10n.paymentActionRestore)
                                .foregroundColor(Color.cAccent)
                                .multilineTextAlignment(.center)
                            }

                            Button(action: {
                                withAnimation {
                                    self.showPrivacySheet = true
                                }
                            }) {
                                Text(L10n.paymentActionTermsAndPrivacy)
                                .foregroundColor(Color.cAccent)
                                .padding(.top, 8)
                                .multilineTextAlignment(.center)
                                .actionSheet(isPresented: self.$showPrivacySheet) {
                                    ActionSheet(title: Text(L10n.paymentActionTermsAndPrivacy), buttons: [
                                        .default(Text(L10n.paymentActionTerms)) {
                                            self.contentVM.openLink(Link.Tos)
                                        },
                                        .default(Text(L10n.paymentActionPolicy)) {
                                            self.contentVM.openLink(Link.Privacy)
                                        },
                                        .default(Text(L10n.universalActionSupport)) {
                                            self.contentVM.openLink(Link.Support)
                                        },
                                        .cancel()
                                    ])
                                }
                            }
                            .padding(.bottom)

                        }
                        .frame(maxWidth: 500)
                        .padding()
                        .alert(isPresented: self.$vm.showError) {
                            Alert(title: Text(L10n.paymentAlertErrorHeader), message: Text(self.vm.error!),
                                dismissButton: Alert.Button.default(
                                    Text(L10n.universalActionClose), action: { self.vm.cancel() }
                                )
                            )
                        }
                        .onAppear {
                            self.vm.fetchOptions()
                        }
                        Spacer()
                    }
                    .background(
                        CurvedShape()
                            .fill(
                                LinearGradient(gradient: Gradient(colors: [Color.cAccent, Color.cPrimaryBackground]),
                                               startPoint: .top,
                                               endPoint: .bottom)
                            )
                    )

                    // Overlay when loading or error
                    HStack {
                        Spacer()
                        VStack {
                            Spacer()
                            if self.vm.working {
                                if #available(iOS 14.0, *) {
                                    ProgressView()
                                        .padding(.bottom)
                                } else {
                                    SpinnerView()
                                        .frame(width: 24, height: 24)
                                        .padding(.bottom)
                                }
                                Text(L10n.universalStatusProcessing)
                                    .multilineTextAlignment(.center)
                            } else if self.vm.error != nil {
                                Text(errorDescriptions[CommonError.paymentFailed]!)
                                    .multilineTextAlignment(.center)
                            }
                            Spacer()
                        }
                        .padding()
                        .frame(maxWidth: 500)
                        Spacer()
                    }
                    .background(Color.cPrimaryBackground)
                    .opacity(self.vm.working || self.vm.error != nil || self.vm.options.isEmpty ? 1.0 : 0.0)
                    .transition(.opacity)
                    .animation(
                        Animation.easeIn(duration: 0.3).repeatCount(1)
                    )
                    .accessibilityHidden(true)
                }
            
        }
    }
}

struct CurvedShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Start at the top left
        path.move(to: CGPoint(x: 0, y: 0))

        // Draw line to the top right
        path.addLine(to: CGPoint(x: rect.width, y: 0))

        // Draw line to the top right at 30% height
        path.addLine(to: CGPoint(x: rect.width, y: rect.height * 0.3))

        // Draw a curve to the top left at 30% height
        path.addCurve(to: CGPoint(x: 0, y: rect.height * 0.2),
                      control1: CGPoint(x: rect.width * 0.75, y: rect.height * 0.25),
                      control2: CGPoint(x: rect.width * 0.25, y: rect.height * 0.35))

        // Close the path (draw line to the start)
        path.closeSubpath()

        return path
    }
}


struct PaymentGatewayView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PaymentGatewayView()
            PaymentGatewayView()
                .environment(\.sizeCategory, .extraExtraExtraLarge)
            PaymentGatewayView()
                .previewDevice(PreviewDevice(rawValue: "iPhone X"))
        }
    }
}