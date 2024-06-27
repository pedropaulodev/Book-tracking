//
//  MybooksApp.swift
//  Mybooks
//
//  Created by PEDRO PAULO DA SILVA on 25/06/24.
//

import SwiftUI
import SwiftData

@main
struct MybooksApp: App {
    var body: some Scene {
        WindowGroup {
            BookListView()
        }
        .modelContainer(for: Book.self)
    }
    init(){
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
