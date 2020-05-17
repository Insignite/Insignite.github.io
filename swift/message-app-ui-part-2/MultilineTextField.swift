//
//  ContentView.swift
//  YouTubeExampleProject
//
//  Created by Khanh Nguyen on 4/15/20.
//  Copyright © 2020 Just Code With Khanh. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var currentMess = ""
    
    var body: some View {
        ZStack {
            Color.black
            
            MultilineText(text: self.$currentMess, placeHolder: "Message", maxViewLine: 3)
        }.edgesIgnoringSafeArea(.all)
    }
}


struct ContentView_Previews : PreviewProvider {
    static var previews : some View {
        ContentView()
    }
}

struct MultilineText : View {
    @State private var viewHeight : CGFloat = 38 // Body font initally size 38
    @Binding var text : String
    private var placeHolder : String
    private var maxViewLine : CGFloat?
    private var onEditChange : (() -> Void)?
    private var onDone : (() -> Void)?
    
    init(text: Binding<String>, placeHolder: String, maxViewLine: CGFloat? = 4, onEditChange: (() -> Void)? = nil, onDone: (() -> Void)? = nil) {
        self._text = text
        self.placeHolder = placeHolder
        self.onEditChange = onEditChange
        self.onDone = onDone
        self.maxViewLine = maxViewLine
    }
    
    var body : some View {
        ZStack(alignment: .topLeading) {
            if self.text.isEmpty {
                Text(placeHolder)
                    .foregroundColor(Color(UIColor.lightGray))
                    .padding([.leading, .trailing], 4)
                    .padding(.top, 8)
            }
            
            TextViewWrapper(text: self.$text,
                            viewheight: self.$viewHeight,
                            placeHolder: self.placeHolder,
                            maxViewLine: self.maxViewLine,
                            onEditChange: self.onEditChange,
                            onDone: self.onDone)
                .frame(maxHeight: self.viewHeight)
        }
    }
}



private struct TextViewWrapper : UIViewRepresentable {
    @Binding var text : String
    @Binding var viewHeight: CGFloat
    var placeHolder : String
    var maxViewLine : CGFloat? // Allow us to set how tall the view is before scroll start
    var onEditChange : (() -> Void)?
    var onDone : (() -> Void)?
    
    init(text: Binding<String>, viewheight: Binding<CGFloat>, placeHolder: String, maxViewLine: CGFloat? = nil, onEditChange: (() -> Void)? = nil, onDone: (() -> Void)? = nil) {
        self._text = text
        self._viewHeight = viewheight
        self.placeHolder = placeHolder
        self.onEditChange = onEditChange
        self.onDone = onDone
        self.maxViewLine = maxViewLine
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = true
        textView.isSelectable = true
        textView.isScrollEnabled = true
        textView.isUserInteractionEnabled = true
        textView.backgroundColor = UIColor.clear
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.delegate = context.coordinator
        textView.textColor = UIColor.white // I use white because dark theme contain black background
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != self.text {
            uiView.text = self.text
            // when message is send, I want to clear out the message. TextView doesn't update this
            // when we change text so manual update it ourself
        }
        
        let predictedSize = uiView.sizeThatFits(CGSize(width: uiView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        let lines = Self.lineCalculator(uiView)
        DispatchQueue.main.async {
            if self.viewHeight != predictedSize.height && lines <= self.maxViewLine! {
                self.viewHeight = predictedSize.height
            } else if lines > self.maxViewLine! {
                self.viewHeight = self.maxViewLine! * uiView.font!.lineHeight
            }
        }
    }
    
    static func lineCalculator(_ textView: UITextView) -> CGFloat {
        // Number 16 is purely calculate base on font size
        // with body font, it always start with 38 then next line add 22 to it
        // to accompany for the initial value of 38, i subtract 16
        let preCalculateLines = (textView.contentSize.height - 16) / textView.font!.lineHeight
        return preCalculateLines.rounded(.down)
    }
    
    typealias UIViewType = UITextView
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, viewheight: $viewHeight, placeHolder: placeHolder, maxViewLine: maxViewLine, onEditChange: onEditChange, onDone: onDone)
    }
    
    class Coordinator : NSObject, UITextViewDelegate {
        @Binding var text : String
        @Binding var viewHeight: CGFloat
        var placeHolder : String
        var maxViewLine : CGFloat? // Allow us to set how tall the view is before scroll start
        var onEditChange : (() -> Void)?
        var onDone : (() -> Void)?
        
        init(text: Binding<String>, viewheight: Binding<CGFloat>, placeHolder: String, maxViewLine: CGFloat? = nil, onEditChange: (() -> Void)? = nil, onDone: (() -> Void)? = nil) {
            self._text = text
            self._viewHeight = viewheight
            self.placeHolder = placeHolder
            self.onEditChange = onEditChange
            self.onDone = onDone
            self.maxViewLine = maxViewLine
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.text = textView.text
            let predictedSize = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
            let lines = TextViewWrapper.lineCalculator(textView)
            DispatchQueue.main.async {
               if self.viewHeight != predictedSize.height && lines <= self.maxViewLine! {
                   self.viewHeight = predictedSize.height
               } else if lines > self.maxViewLine! {
                   self.viewHeight = self.maxViewLine! * textView.font!.lineHeight
               }
            }
        }
    }
}
