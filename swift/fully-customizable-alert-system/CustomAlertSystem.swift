//
//  ContentView.swift
//  YouTubeExampleProject
//
//  Created by Khanh Nguyen on 4/15/20.
//  Copyright © 2020 Just Code With Khanh. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var showAlert1 = false
    @State var showAlert2 = false
    @State var showAlert3 = false
    
    var body: some View {
        VStack(spacing: 40) {
            Button(action: {
                self.showAlert1 = true
            }) {
                Text("Show alert 1")
            }
            
            Button(action: {
                self.showAlert2 = true
            }) {
                Text("Show alert 2")
            }
            
            Button(action: {
                self.showAlert3 = true
            }) {
                Text("Show alert 3")
            }
            
        }.cAlert(isPresented: self.$showAlert1) {
            CAlert(title: Text("Error 1"), dismissButton: .cancel())
        }.cAlert(isPresented: self.$showAlert2) {
            CAlert(title: Text("Error 2"), message: Text("Sample text holder for error 2"), dismissButton: .default(Text("Dismiss")))
        }.cAlert(isPresented: self.$showAlert3) {
            CAlert(title: Text("Error 3"), primaryButton: .cancel(), secondaryButton: .destructive(Text("Delete")))
        }
        
    }
}



struct ContentView_Previews : PreviewProvider {
    static var previews : some View {
        ContentView()
    }
}

// Get Screen size
struct Screen {
    static let height = UIScreen.main.bounds.height
    static let width = UIScreen.main.bounds.width
}

public struct CAlert {
    var title : Text
    var message : Text?
    var primaryButton : CAlert.Button?
    var secondaryButton : CAlert.Button?

    /// Creates an alert with one button.
    public init(title: Text, message: Text? = nil, dismissButton: CAlert.Button? = nil) {
        self.title = title
        self.message = message
        self.primaryButton = dismissButton
    }

    /// Creates an alert with two buttons.
    ///
    /// - Note: the system determines the visual ordering of the buttons.
    public init(title: Text, message: Text? = nil, primaryButton: CAlert.Button, secondaryButton: CAlert.Button) {
        self.title = title
        self.message = message
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
    }

    /// A button representing an operation of an alert presentation.
    public struct Button {
        var label : Text
        var action : (() -> Void)?

        /// Creates an `Alert.Button` with the default style.
        public static func `default`(_ label: Text, action: (() -> Void)? = nil) -> CAlert.Button {
            return Button(label: label, action: action)
        }

        /// Creates an `Alert.Button` that indicates cancellation of some
        /// operation.
        public static func cancel(_ label: Text, action: (() -> Void)? = nil) -> CAlert.Button {
            return Button(label: label, action: action)
        }

        /// Creates an `Alert.Button` that indicates cancellation of some
        /// operation.
        ///
        /// - Note: the label of the button is automatically chosen by the
        /// system for the appropriate locale.
        public static func cancel(_ action: (() -> Void)? = nil) -> CAlert.Button {
            return Button(label: Text("Cancel"), action: action)
        }

        /// Creates an `Alert.Button` with a style indicating destruction of
        /// some data.
        public static func destructive(_ label: Text, action: (() -> Void)? = nil) -> CAlert.Button {
            return Button(label: label.foregroundColor(.red), action: action)
        }
    }
}

public struct CAlertWrapper : ViewModifier {
    @Binding var isPresented : Bool
    var content : CAlert
    
    init(isPresented: Binding<Bool>, content : () -> CAlert) {
        self._isPresented = isPresented
        self.content = content()
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content.animation(.linear)
            
            if isPresented {
                Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
                // alert
                VStack {
                    VStack(spacing: 10) {
                        self.content.title
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                        if self.content.message != nil {
                            self.content.message?.font(.footnote)
                        } else {
                            Text("")
                        }
                    }.padding([.leading, .trailing, .top], 15)
                    
                    Spacer(minLength: 0)
                    VStack(spacing: 0) {
                        Divider()
                        HStack {
                            Button(action: self.content.primaryButton?.action != nil ?
                                (self.content.primaryButton?.action)! :
                                {self.isPresented = false}) {
                                HStack {
                                    Spacer()
                                    self.content.primaryButton?.label ?? Text("Dismiss")
                                    Spacer()
                                }
                            }
                            
                            if self.content.secondaryButton != nil {
                                Divider()
                                Button(action: self.content.secondaryButton?.action != nil ?
                                (self.content.secondaryButton?.action)! :
                                    {self.isPresented = false}) {
                                    HStack {
                                        Spacer()
                                        self.content.secondaryButton!.label
                                        Spacer()
                                    }
                                }
                            }
                        }.frame(height: Screen.height * 0.06)
                    }
                }.animation(.linear)
                    .frame(width: Screen.width * 0.8, height: Screen.height * 0.2)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.white)
                )
            }
        }
    }
}


extension View {
    public func cAlert(isPresented : Binding<Bool>, content : () -> CAlert) -> some View {
        self.modifier(CAlertWrapper(isPresented: isPresented, content: content))
    }
}
