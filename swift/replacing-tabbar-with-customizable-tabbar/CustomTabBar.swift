//
//  ContentView.swift
//  YouTubeExampleProject
//
//  Created by Khanh Nguyen on 4/15/20.
//  Copyright © 2020 Just Code With Khanh. All rights reserved.
//

import SwiftUI

struct TabBarWrapper: UIViewControllerRepresentable {
    @Binding var selection: Int
    var tabVC: [UINavigationController]
    
    init(selection: Binding<Int>, tabs tabVC: () -> [TabItem]) {
        self._selection = selection
        self.tabVC = tabVC().map { item in
            let hostVC = UIHostingController(rootView: item.contentView)
            hostVC.tabBarItem = item.item
            return UINavigationController(rootViewController: hostVC)
        }
    }
    
    func makeUIViewController(context: Context) -> UITabBarController {
        let tabBarVC = UITabBarController()
        setUpTabBar(tabBarVC, context: context)
        return tabBarVC
    }
    
    func updateUIViewController(_ uiViewController: UITabBarController, context: Context) {
        uiViewController.selectedIndex = selection
    }
    
    func setUpTabBar(_ tabVC: UITabBarController, context: Context) {
        tabVC.viewControllers = self.tabVC
        tabVC.delegate = context.coordinator
        tabVC.tabBar.tintColor = .black
        tabVC.tabBar.isTranslucent = false
        tabVC.tabBar.shadowImage = UIImage()
        tabVC.tabBar.backgroundImage = UIImage()
    }
    
    typealias UIViewControllerType = UITabBarController
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(selection: $selection)
    }
    
    class Coordinator: NSObject, UITabBarControllerDelegate {
        @Binding var selection: Int
        
        init(selection: Binding<Int>) {
            self._selection = selection
        }
        
        func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            // Do something here if want more custom
            self.selection = tabBarController.selectedIndex
            if selection == 1 {
                tabBarController.tabBar.barTintColor = .red
            } else {
                tabBarController.tabBar.barTintColor = .blue
            }
        }
    }
    
    struct TabItem {
        var item: UITabBarItem
        var contentView: AnyView
        
        init<T:View>(item: UITabBarItem, view contentView: T) {
            self.item = item
            self.contentView = AnyView(contentView)
        }
        
        init<T:View>(title: String? = "", image: UIImage? = nil, selectedImage: UIImage? = nil, view contentView: () -> T) {
            let item  = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
            item.selectedImage = selectedImage
            self.init(item: item, view: contentView())
        }
    }
}

extension View {
    func tabItem(title: String?, image: UIImage? = nil, selectedImage: UIImage? = nil) -> TabBarWrapper.TabItem {
        return TabBarWrapper.TabItem(title: title, image: image, selectedImage: image) { self }
    }
}
