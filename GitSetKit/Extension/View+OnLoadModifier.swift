//
//  View+OnLoadModifier.swift
//  GitSetKit
//
//  Created by 최명근 on 2023/07/20.
//

import SwiftUI

extension View {
    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        self.modifier(OnLoadModifier(action: action))
    }
}
