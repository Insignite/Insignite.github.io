//
//  ContentView.swift
//  ExampleProject
//
//  Created by Khanh Nguyen on 7/3/20.
//  Copyright © 2020 Just Code With Khanh. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var offset: CGFloat = .zero
    
    var body: some View {
        VStack {
            Text("\(offset)")
            
            TrackScrollView(offset: $offset) {
                ForEach(0..<50) {
                    Text("\($0)")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct TrackScrollView<Content:View>: View {
    let axes: Axis.Set
    let showIndicators: Bool
    let content: Content
    @Binding var offset: CGFloat
    
    init(_ axes: Axis.Set = .vertical, showIndicators: Bool = true, offset: Binding<CGFloat>, @ViewBuilder content: () -> Content) {
        self.axes = axes
        self.showIndicators = showIndicators
        self._offset = offset
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { outReader in
            ScrollView(self.axes, showsIndicators: self.showIndicators) {
                ZStack(alignment: self.axes == .vertical ? .top : .leading) {
                    GeometryReader { inReader in
                        Color.clear.preference(key: ScrollViewPreferenceKey.self, value: self.handleCalculateOffset(outterProxy: outReader, innerProxy: inReader))
                    }
                    
                    if self.axes == .vertical {
                        VStack { self.content }
                    } else { HStack { self.content }}
                    
                }
            }.onPreferenceChange(ScrollViewPreferenceKey.self) { value in
                self.offset = value[0]
            }
        }
    }
    
    private func handleCalculateOffset(outterProxy: GeometryProxy, innerProxy: GeometryProxy) -> [CGFloat] {
        return self.axes == .vertical ? [outterProxy.frame(in: .global).minY - innerProxy.frame(in: .global).minY] :
        [outterProxy.frame(in: .global).minX - innerProxy.frame(in: .global).minX]
    }
}

struct ScrollViewPreferenceKey: PreferenceKey {
    typealias Value = [CGFloat]
    
    static var defaultValue: [CGFloat] = [.zero]
    
    static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
        value.append(contentsOf: nextValue())
    }
}
