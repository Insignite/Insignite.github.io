//
//  ContentView.swift
//  YouTubeExampleProject
//
//  Created by Khanh Nguyen on 4/15/20.
//  Copyright © 2020 Just Code With Khanh. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var isPresented  = false
    
    var body: some View {
        ZStack {
            Color.red
            
            Text("home").onTapGesture {
                self.isPresented.toggle()
            }
        }.modalSheet(isPresented: $isPresented, transition: ModalTransition.edgeBottom) {
            ZStack {
                Color.purple
                
                Text("modal").onTapGesture {
                    self.isPresented.toggle()
                }
            }
        }
    }
}

struct ContentView_Previews : PreviewProvider {
    static var previews : some View {
        ContentView()
    }
}





struct ModalViewModifier<Destination>: ViewModifier where Destination : View {
    @Binding var isPresented : Bool
    var destination : () -> Destination
    var transitionType : ModalTransition
    
    func body(content: Self.Content) -> some View {
        ZStack {
            if self.isPresented {
                self.destination()
                .transition(self.transitionType.transition)
                .animation(.linear)
                .edgesIgnoringSafeArea(.all)
            } else {
                content
                .transition(self.transitionType.transition)
                .animation(.linear)
            }
        }
    }
}


extension View {
    func modalSheet<Destination : View>(isPresented: Binding<Bool>, transition transitionType : ModalTransition, destination: @escaping () -> Destination) -> some View {
        self.modifier(ModalViewModifier(isPresented: isPresented, destination: destination, transitionType: transitionType))
    }
}

protocol TransitionLinkType {
    var transition : AnyTransition { get }
}

enum ModalTransition: TransitionLinkType{
    case edgeBottom, slide, edgeTop
    
    var transition: AnyTransition {
        switch self {
            case .edgeBottom:
                return .move(edge: .bottom)
            case .slide:
                return .slide
        case .edgeTop:
            return .move(edge: .top)
        }
    }
}
