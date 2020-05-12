import SwiftUI

struct ContentView: View {
    @State private var messages : [Message] = [
        Message(uid: "2", message: "Hello. This is first text"),
        Message(uid: "2", message: "Hey got my txt?"),
        Message(uid: "1", message: "I got your first txt"),
        Message(uid: "2", message: "Gotcha")]
    @State private var currentMess = ""
    
    var body: some View {
        ZStack {
            Color.black
            
            VStack(spacing: 0) {
                NavigationBar
                ReverseScrollView {
                    VStack(alignment: .leading,spacing: 15) {
                        ForEach(self.messages) { message in
                            HStack {
                                if message.uid == "1" {
                                    Spacer()
                                    Text(message.message)
                                        .foregroundColor(.white)
                                        .padding(10)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10).foregroundColor(Color(UIColor.systemBlue))
                                    )
                                } else {
                                    Text(message.message)
                                        .foregroundColor(.white)
                                        .padding(10)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10).foregroundColor(Color(UIColor.systemGray))
                                    )
                                    Spacer()
                                }
                            }.padding([.trailing, .leading], 15)
                        }
                    }.padding(.bottom, 10)
                }
                TextBarView
                .background(Color.black)
                .padding(.bottom, 10)
            }
        }.edgesIgnoringSafeArea(.all)
    }
    
    var TextBarView : some View {
        HStack {
            ZStack(alignment: .leading) {
                if self.currentMess.isEmpty {
                    Text("Message").foregroundColor(.gray)
                }


                TextField("", text: self.$currentMess).foregroundColor(.white)
            }

            Button(action: {
                self.messages.append(Message(uid: "1", message: self.currentMess))
                self.currentMess = ""
            }) {
                Image(systemName: "arrow.up")
                    .foregroundColor(self.currentMess.isEmpty ? .black : .white)
                .background(
                    Circle()
                        .frame(width: 25, height: 25)
                        .foregroundColor(self.currentMess.isEmpty ? Color.gray : Color(UIColor.systemBlue))
                )
            }
            .disabled(self.currentMess.isEmpty ? true : false)
        }.padding([.trailing, .leading], 10)
        .padding(5)
        .background(
            RoundedRectangle(cornerRadius: 20).stroke()
                .foregroundColor(.gray)
        ).frame(width: Screen.width * 0.95)
    }
    
    var NavigationBar : some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .foregroundColor(Color.black)
            HStack {
                Button(action: {
                    
                }) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                VStack(spacing: 0) {
                    Image("avatar")
                        .resizable()
                        .frame(width: 40, height: 40)
                    Text("JCWKhanh").font(.caption).foregroundColor(.white)
                }
                Spacer()
            }.padding()
            .frame(height: Screen.height * 0.075)
        }.frame(height: Screen.height * 0.12)
    }
}

struct CoontentView_Previews : PreviewProvider {
    static var previews : some View {
        ContentView()
    }
}


struct ReverseScrollView<Content: View> : View {
    @State private var contentHeight: CGFloat = CGFloat.zero
    @State private var scrollOffset: CGFloat = CGFloat.zero
    @State private var currentOffset: CGFloat = CGFloat.zero

    var content : Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body : some View {
        GeometryReader { outReader in
            VStack {
                self.content
                    .background(
                        GeometryReader { inReader in
                            Color.clear.preference(key: ViewHeightKey.self, value: inReader.size.height)
                        })
            }
            .onPreferenceChange(ViewHeightKey.self) {
                self.updateContentHeight(with: $0, outHeight: outReader.size.height)
            }
            .frame(height: outReader.size.height, alignment: .bottom)
            .offset(y: self.currentOffset + self.scrollOffset)
            .animation(.easeInOut)
            .gesture( DragGesture()
               .onChanged({ self.onDragChanged($0) })
               .onEnded({ self.onDragEnded($0, outHeight: outReader.size.height)})
            )
            
        }
    }
    
    func onDragChanged(_ value: DragGesture.Value) {
        self.scrollOffset = value.translation.height
    }
    
    func onDragEnded(_ value: DragGesture.Value, outHeight: CGFloat) {
        let scrollOffset = value.translation.height
        updateOffset(with: scrollOffset, outHeight: outHeight)
        self.scrollOffset = 0

    }
    
    func updateContentHeight(with height: CGFloat, outHeight: CGFloat) {
        let topLimit = self.contentHeight - height
        self.currentOffset = outHeight - height
        self.contentHeight = height
        self.updateOffset(with: topLimit, outHeight: outHeight)
    }
    
    func updateOffset(with scrollOffset : CGFloat, outHeight: CGFloat) {
        let topLimit = self.contentHeight - outHeight
        
        if topLimit < .zero {
            self.currentOffset = .zero
        } else {
            var predictedOffset = currentOffset + scrollOffset
            if predictedOffset < .zero {
                predictedOffset = .zero
            } else if predictedOffset > topLimit {
                predictedOffset = topLimit
            }
            self.currentOffset = predictedOffset
        }
    }
}

struct ViewHeightKey : PreferenceKey {
    static var defaultValue = CGFloat.zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

