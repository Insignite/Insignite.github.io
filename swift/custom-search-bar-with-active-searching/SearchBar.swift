//
//  ContentView.swift
//  YouTubeExampleProject
//
//  Created by Khanh Nguyen on 4/15/20.
//  Copyright © 2020 Just Code With Khanh. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var searchData = ""
    @State private var sortType = SortType.az
    @State private var showAction = false
    
    var datas = [SampleData(name: "Google", img: "img1"),
                 SampleData(name: "Apple", img: "img2"),
                SampleData(name: "Facebook", img: "img3"),
                SampleData(name: "Netflix", img: "img4"),
                SampleData(name: "Amazon", img: "img5")]
    
    var body: some View {
        VStack{
            SearchBar(text: $searchData).padding([.leading, .trailing])
            HStack {
                Spacer()
                Button(action: {
                    self.showAction = true
                }) {
                    Text("Sort By: \(self.sortType.rawValue)").font(.footnote)
                }
            }.padding([.leading, .trailing])
            Divider()
            List {
                ForEach(filterSort().filter {
                    if searchData.isEmpty {
                        return true
                    } else {
                        return $0.name.lowercased().contains(self.searchData.lowercased())
                    }
                }, id: \.self) { data in
                    HStack {
                        Image(data.img).resizable().clipShape(Circle()).frame(width: 45, height: 45)
                        Text(data.name)
                        Spacer()
                    }
                }
            }
        }.actionSheet(isPresented: $showAction) {
            ActionSheet(title: Text(""), message: Text("Choose your sorting method"), buttons:
                [.default(Text(SortType.az.rawValue), action: { self.sortType = .az }),
                .default(Text(SortType.za.rawValue), action: { self.sortType = .za }),
                .default(Text(SortType.timeAsc.rawValue), action: { self.sortType = .timeAsc }),
                .default(Text(SortType.timeDes.rawValue), action: { self.sortType = .timeDes }),
                .cancel()])
        }
    }
    
    func filterSort() -> [SampleData] {
        switch sortType {
        case .az:
            return datas.sorted { $0.name < $1.name }
        case .za:
            return datas.sorted { $0.name > $1.name }
        case .timeAsc:
            return datas.sorted { $0.date < $1.date }
        case .timeDes:
            return datas.sorted { $0.date > $1.date }
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

//
// MARK: Sample data
struct SampleData : Hashable {
    var id = UUID()
    var name : String
    var img : String
    var date = Date()
}

//
// MARK: Sort Type
enum SortType : String {
    case az = "Name Asc"
    case za = "Name Des"
    case timeAsc = "Time Asc"
    case timeDes = "Time Des"
}


//
// MARK: Search Bar
struct SearchBar : View {
    @Binding var text : String
    
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass").foregroundColor(.black)
            TextField("Search", text: $text)
            Spacer(minLength: 0)
            if !text.isEmpty {
                Button(action: {
                    self.text = ""
                }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .foregroundColor(Color(UIColor.systemGray6))
                        .frame(width: 8, height: 8)
                        .background(Circle().foregroundColor(Color(UIColor.systemGray2)).frame(width: 16, height: 16))
                }
            }
        }.padding(5)
            .padding([.leading, .trailing], 6)
            .background(RoundedRectangle(cornerRadius: 30).foregroundColor(Color(UIColor.systemGray6)))
            .frame(maxWidth: .infinity)
    }
}
