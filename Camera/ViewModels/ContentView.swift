//
//  ContentView.swift
//  Camera
//
//  Created by Khayrul on 2/9/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var model = ContentViewModel()

    var body: some View {
        FrameView(image: model.frame)
            .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
