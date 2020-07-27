//
//  ContentView.swift
//  YouTubeExampleProject
//
//  Created by Khanh Nguyen on 4/15/20.
//  Copyright © 2020 Just Code With Khanh. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var isExpand = false
    @State var activeId = UUID()

    var body: some View {
        ZStack {
            Color(self.isExpand ? UIColor.systemGray2 : .white).edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("SATURDAY, MAY 2")
                        .foregroundColor(Color(UIColor.systemGray))
                    HStack {
                        Text("Today")
                            .font(.system(.title))
                            .fontWeight(.semibold)
                        Spacer()
                        Image("avatar")
                        .resizable()
                            .frame(width: 35, height: 35)
                            .onTapGesture {
                                // this also work with dynamic adding more item to the list
                                self.items.append(Item(title: "View Today Post", subTitle: "Learn more and keep learning.", image: "img5", content: "There was something in the tree. It was difficult to tell from the ground, but Rachael could see movement. She squinted her eyes and peered in the direction of the movement, trying to decipher exactly what she had spied. The more she peered, however, the more she thought it might be a figment of her imagination. Nothing seemed to move until the moment she began to take her eyes off the tree. Then in the corner of her eye, she would see the movement again and begin the process of staring again. \n Out of another, I get a lovely view of the bay and a little private wharf belonging to the estate. There is a beautiful shaded lane that runs down there from the house. I always fancy I see people walking in these numerous paths and arbors, but John has cautioned me not to give way to fancy in the least. He says that with my imaginative power and habit of story-making a nervous weakness like mine is sure to lead to all manner of excited fancies and that I ought to use my will and good sense to check the tendency. So I try.\n He sat staring at the person in the train stopped at the station going in the opposite direction. She sat staring ahead, never noticing that she was being watched. Both trains began to move and he knew that in another timeline or in another universe, they had been happy together."))
                        }
                    }
                }.padding()
                .opacity(self.isExpand ? 0 : 1)
                
                // Let's seperate each item by using their UUID
                VStack(spacing: 30) {
                    ForEach(items) { item in
                        GeometryReader { reader in
                            ExpandView(isExpand: self.$isExpand, activeId: self.$activeId, data: item)
                                .offset(y: self.activeId == item.id ? -reader.frame(in: .global).minY : 0)
                                .opacity(self.activeId != item.id && self.isExpand ? 0 : 1) // If not current card and expand mode is true, hide it
                        }.frame(height: Screen.height * 0.45)
                        .frame(maxWidth: self.isExpand ? Screen.width : Screen.width * 0.9)
                    }
                }
                
                
                    
            }
        }
    }
    
    @State var items = [
        Item(title: "View Today Post", subTitle: "Learn more and keep learning.", image: "img1", content: "There was something in the tree. It was difficult to tell from the ground, but Rachael could see movement. She squinted her eyes and peered in the direction of the movement, trying to decipher exactly what she had spied. The more she peered, however, the more she thought it might be a figment of her imagination. Nothing seemed to move until the moment she began to take her eyes off the tree. Then in the corner of her eye, she would see the movement again and begin the process of staring again. \n Out of another, I get a lovely view of the bay and a little private wharf belonging to the estate. There is a beautiful shaded lane that runs down there from the house. I always fancy I see people walking in these numerous paths and arbors, but John has cautioned me not to give way to fancy in the least. He says that with my imaginative power and habit of story-making a nervous weakness like mine is sure to lead to all manner of excited fancies and that I ought to use my will and good sense to check the tendency. So I try.\n He sat staring at the person in the train stopped at the station going in the opposite direction. She sat staring ahead, never noticing that she was being watched. Both trains began to move and he knew that in another timeline or in another universe, they had been happy together."),
        Item(title: "Unity Planet", subTitle: "Build the game you always dream of.", image: "img2", content: "There was something in the tree. It was difficult to tell from the ground, but Rachael could see movement. She squinted her eyes and peered in the direction of the movement, trying to decipher exactly what she had spied. The more she peered, however, the more she thought it might be a figment of her imagination. Nothing seemed to move until the moment she began to take her eyes off the tree. Then in the corner of her eye, she would see the movement again and begin the process of staring again. \n Out of another, I get a lovely view of the bay and a little private wharf belonging to the estate. There is a beautiful shaded lane that runs down there from the house. I always fancy I see people walking in these numerous paths and arbors, but John has cautioned me not to give way to fancy in the least. He says that with my imaginative power and habit of story-making a nervous weakness like mine is sure to lead to all manner of excited fancies and that I ought to use my will and good sense to check the tendency. So I try. \n He sat staring at the person in the train stopped at the station going in the opposite direction. She sat staring ahead, never noticing that she was being watched. Both trains began to move and he knew that in another timeline or in another universe, they had been happy together."),
        Item(title: "Firewatch View", subTitle: "Follow your passion, it will guide your life", image: "img3", content: "There was something in the tree. It was difficult to tell from the ground, but Rachael could see movement. She squinted her eyes and peered in the direction of the movement, trying to decipher exactly what she had spied. The more she peered, however, the more she thought it might be a figment of her imagination. Nothing seemed to move until the moment she began to take her eyes off the tree. Then in the corner of her eye, she would see the movement again and begin the process of staring again. \n Out of another, I get a lovely view of the bay and a little private wharf belonging to the estate. There is a beautiful shaded lane that runs down there from the house. I always fancy I see people walking in these numerous paths and arbors, but John has cautioned me not to give way to fancy in the least. He says that with my imaginative power and habit of story-making a nervous weakness like mine is sure to lead to all manner of excited fancies and that I ought to use my will and good sense to check the tendency. So I try.\n He sat staring at the person in the train stopped at the station going in the opposite direction. She sat staring ahead, never noticing that she was being watched. Both trains began to move and he knew that in another timeline or in another universe, they had been happy together."),
        Item(title: "Rocket Man Riding Through The Universe", subTitle: "Nothing better than riding through the universe.", image: "img4", content: "There was something in the tree. It was difficult to tell from the ground, but Rachael could see movement. She squinted her eyes and peered in the direction of the movement, trying to decipher exactly what she had spied. The more she peered, however, the more she thought it might be a figment of her imagination. Nothing seemed to move until the moment she began to take her eyes off the tree. Then in the corner of her eye, she would see the movement again and begin the process of staring again. \n Out of another, I get a lovely view of the bay and a little private wharf belonging to the estate. There is a beautiful shaded lane that runs down there from the house. I always fancy I see people walking in these numerous paths and arbors, but John has cautioned me not to give way to fancy in the least. He says that with my imaginative power and habit of story-making a nervous weakness like mine is sure to lead to all manner of excited fancies and that I ought to use my will and good sense to check the tendency. So I try.\n He sat staring at the person in the train stopped at the station going in the opposite direction. She sat staring ahead, never noticing that she was being watched. Both trains began to move and he knew that in another timeline or in another universe, they had been happy together.")
    ]
}

struct ExpandView : View {
    @State var dragValue = CGSize.zero
    
    @Binding var isExpand : Bool
    @Binding var activeId : UUID
    var data : Item
    
    var body : some View {
        ZStack(alignment: .top) {
            Image(data.image)
            .resizable()
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 5)
            .onTapGesture {
                self.isExpand = true
                self.activeId = self.data.id
            }
            .opacity(self.activeId == data.id ? 0 : 1)
            
            // Title section
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text(data.subTitle)
                        .foregroundColor(Color(UIColor.systemGray))
                        .fontWeight(.semibold)
                    
                    Text(data.title)
                        .font(.system(.title))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                Spacer()
            }.padding()
            .opacity(self.activeId == data.id ? 0 : 1)
            
            
            // Over lay content
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)
                
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: 20) {
                        Image(data.image)
                            .resizable()
                            .frame(maxHeight: Screen.height * 0.45)
                        
                        Text(data.content)
                            .foregroundColor(.black)
                            .padding()
                    }.padding(.bottom)
                }.edgesIgnoringSafeArea(.all)
                
                // Making close button
                VStack {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            self.isExpand = false
                            self.activeId = UUID()
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(Color.white.opacity(0.2))
                        }.frame(width: 30, height: 30)
                        .background(
                            Circle().foregroundColor(Color.white.opacity(0.6))
                        )
                    }.padding(.top, 30)
                    
                    Spacer()
                }.padding()
            }.opacity(self.activeId == data.id ? 1 : 0)
            .gesture(
                self.activeId == data.id ?
                    DragGesture().onChanged({ value in
                    guard value.translation.height < 200 else {return}
                        if value.translation.height > 400 {
                            self.isExpand = false
                            self.activeId = UUID()
                            self.dragValue = .zero
                        } else {
                            self.dragValue = value.translation
                        }
                    }).onEnded({ value in
                        if value.translation.height > 300 {
                            self.isExpand = false
                            self.activeId = UUID()
                        }
                            self.dragValue = .zero
                    }) : nil
            ).scaleEffect(1 - (self.dragValue.height / 1000))
            
        }// ZStack
            .frame(height: self.activeId == self.data.id ? Screen.height : Screen.height * 0.45)
            .animation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.6))
            .edgesIgnoringSafeArea(.all)
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
    var subTitle : String
    var image : String
    var content : String
}

// Get Screen size
struct Screen {
    static let height = UIScreen.main.bounds.height
    static let width = UIScreen.main.bounds.width
}
