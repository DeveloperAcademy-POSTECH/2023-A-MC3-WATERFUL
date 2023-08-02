//
//  View+ViewDidLoad.swift
//  GitSetKit
//
//  Created by 최명근 on 2023/07/20.
//

import SwiftUI

struct OnLoadModifier: ViewModifier {
    @State private var viewDidLoad = false
    
    let action: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if viewDidLoad == false {
                    viewDidLoad = true
                    action?()
                }
            }
    }
}
