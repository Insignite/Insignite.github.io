//
//  ContentView.swift
//  YouTubeExampleProject
//
//  Created by Khanh Nguyen on 4/15/20.
//  Copyright © 2020 Just Code With Khanh. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var isExpand = false
    @State private var activePage = UUID()
    @State private var lastPage = UUID()

    var body: some View {
        ZStack {
            Color(UIColor.systemGray3)
            
            GeometryReader { topReader in
                VStack(spacing: 0) {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 80) {
                            Color.clear.frame(height: Screen.height * 0.005)
                            
                            VStack(spacing: 0) {
                                ForEach(self.items) { item in
                                    GeometryReader { inReader in
                                        PageView(isExpand: self.$isExpand, activePage: self.$activePage, lastPage: self.$lastPage, data: item)
                                            .rotation3DEffect(
                                                .degrees(self.activePage == item.id ? 0 : Double(inReader.frame(in: .global).maxY) / -30),
                                                axis: (x: 1, y: 0, z: 0))
                                            .animation(.linear)
                                            .offset(y: self.activePage == item.id ? -inReader.frame(in: .global).minY : 0)
                                            .opacity(self.activePage != item.id && self.isExpand ? 0 : 1)
                                    }.frame(width: Screen.width * 0.8,
                                            height:
                                                self.items.last != nil && self.items.last!.id == item.id ?
                                                    Screen.height * 0.08 : Screen.height * 0.2)
                                    
                                }
                            }.frame(width: Screen.width)
                            
                            // Making history section
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(spacing: 10) {
                                    Image(systemName: "cloud")
                                        .foregroundColor(.white)
                                    Text("My Macbook Pro")
                                        .foregroundColor(.white)
                                }.padding(.bottom, 10)
                                
                                Divider()
                                
                                ForEach(self.urlItem) { url in
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(url.title).foregroundColor(.white)
                                            .fixedSize(horizontal: true, vertical: false)
                                            .lineLimit(1)
                                            .padding(.bottom, 10)
                                        Divider()
                                    }.padding(4)
                                }
                            }.padding(.leading, 10)
                            .background(
                                Rectangle().foregroundColor(.clear)
                            ).frame(width: Screen.width, height: Screen.height * 0.4)
                                .opacity(self.isExpand ? 0 : 1)
                            
                        }
                    }
                    
                    ZStack(alignment: .bottom) {
                        Rectangle().foregroundColor(Color(UIColor.tertiaryLabel))
                        
                        Group {
                            if self.isExpand {
                                // Expand menu
                                HStack(alignment: .lastTextBaseline, spacing: 10) {
                                    Button(action: {
                                        
                                    }) {
                                        Image(systemName: "chevron.left")
                                            .foregroundColor(.white)
                                    }
                                    Spacer()
                                    
                                    Button(action: {
                                        
                                    }) {
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.white)
                                    }
                                    Spacer()
                                    
                                    Button(action: {
                                        
                                    }) {
                                        Image(systemName: "square.and.arrow.up")
                                        .resizable()
                                            .frame(width: 18, height: 18)
                                            .foregroundColor(.white)
                                    }
                                    Spacer()
                                    
                                    Button(action: {
                                        self.isExpand = false
                                        self.activePage = UUID()
                                    }) {
                                        Image(systemName: "square.on.square")
                                            .resizable()
                                            .frame(width: 18, height: 18)
                                            .foregroundColor(.white)
                                    }
                                    
                                }
                            } else {
                                HStack(alignment: .lastTextBaseline, spacing: 10) {
                                    Button(action: {
                                        
                                    }) {
                                        Text("Private")
                                            .foregroundColor(.white)
                                    }
                                    Spacer()
                                    
                                    Button(action: {
                                        self.items.append(Item(title: "Rocket Man Riding Through The Universe", image: "img4"))
                                        self.activePage = self.items.last!.id
                                        self.isExpand = true
                                    }) {
                                        Image(systemName: "plus")
                                        .resizable()
                                            .frame(width: 18, height: 18)
                                            .foregroundColor(.white)
                                    }
                                    Spacer()
                                    
                                    Button(action: {
                                        self.activePage = self.lastPage
                                        self.isExpand = true
                                    }) {
                                        Text("Done")
                                            .foregroundColor(.white)
                                    }
                                    
                                }
                            }
                        }.padding()
                            .frame(height: Screen.height * 0.055)
                            .padding(.bottom, topReader.safeAreaInsets.bottom)
                    }.frame(height: Screen.height * 0.1)
                }
            }
        }.edgesIgnoringSafeArea(.all)
    }
    
    // Use for page
    @State var items = [
        Item(title: "View Today Post", image: "img1"),
        Item(title: "Unity Planet", image: "img2"),
        Item(title: "Firewatch View", image: "img3"),
        Item(title: "Rocket Man Riding Through The Universe", image: "img4"),
        Item(title: "View Today Post", image: "img1"),
        Item(title: "Unity Planet", image: "img2")
    ]
    
    // History url
    let urlItem = [
        Item(title: "View Today Post", image: "img1"),
        Item(title: "Unity Planet", image: "img2"),
        Item(title: "Firewatch View", image: "img3"),
        Item(title: "Rocket Man Riding Through The Universe", image: "img4"),
        Item(title: "View Today Post", image: "img1"),
        Item(title: "Unity Planet", image: "img2"),
        Item(title: "Firewatch View", image: "img3")
    ]
}


// Page view
struct PageView : View {
    @Binding var isExpand : Bool
    @Binding var activePage : UUID
    @Binding var lastPage : UUID
    
    var data : Item
    var body : some View {
        ZStack(alignment: .top) {
            Image(data.image)
            .resizable()
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 5)
                .onTapGesture {
                    self.isExpand = true
                    self.activePage = self.data.id
                    self.lastPage = self.data.id
            }
            
            VStack(spacing: 0) {
                HStack {
                    Button(action : {
                        // Close page button
                        self.isExpand = false
                        self.activePage = UUID()
                        self.lastPage = UUID()
                    }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.white)
                    }.padding(2)
                        .padding(.leading, 5)
                    
                    Spacer()
                    
                    Text(data.title).foregroundColor(.white)
                    .fixedSize(horizontal: true, vertical: false)
                    .lineLimit(1)
                        .font(.caption)
                    .padding(2)
                    
                    Spacer()
                }.background(RoundedRectangle(cornerRadius: 4).foregroundColor(Color(UIColor.systemGray)))
                
                Spacer()
            }.opacity(self.activePage == data.id ? 0 : 1)
        }
        .frame(height : self.activePage == data.id ? Screen.height :Screen.height * 0.5)
        .frame(width: self.activePage == data.id ? Screen.width : Screen.width * 0.8)
        .edgesIgnoringSafeArea(.all)
        .offset(x: self.activePage == data.id ? Screen.width * -0.1 : 0)
    }
}

struct ContentView_Previews : PreviewProvider {
    static var previews : some View {
        ContentView()
    }
}

// Item for data
struct Item : Identifiable {
    var id = UUID()
    var title : String
    var image : String
}

// Get Screen size
struct Screen {
    static let height = UIScreen.main.bounds.height
    static let width = UIScreen.main.bounds.width
}
