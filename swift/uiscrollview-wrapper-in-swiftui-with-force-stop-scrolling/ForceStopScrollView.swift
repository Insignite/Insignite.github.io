//
//  ContentView.swift
//  ExampleProject
//
//  Created by Khanh Nguyen on 7/3/20.
//  Copyright © 2020 Just Code With Khanh. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ForceStopScrollView {
            ForEach(0..<150) {
                Text("\($0)")
            }
        }
    }
}

struct ForceStopScrollView<Content:View>: UIViewRepresentable {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let view = UIScrollView()
        view.delegate = context.coordinator
        view.isScrollEnabled = true
        // Add child
        let child = UIHostingController(rootView: content)
        view.addSubview(child.view)
        // Size
        let newSize = child.view.sizeThatFits(CGSize(width: Screen.width, height: .greatestFiniteMagnitude))
        child.view.frame = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        view.contentSize = newSize
        return view
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
            let yOffset = scrollView.contentOffset.y
            if (yOffset + Screen.height <= scrollView.contentSize.height) && (yOffset > -20) {
                scrollView.setContentOffset(scrollView.contentOffset, animated: false)
            }
        }
    }
    
    typealias UIViewType = UIScrollView
    

}

struct Screen {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
}
