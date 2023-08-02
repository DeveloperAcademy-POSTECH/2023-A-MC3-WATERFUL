//
//  FlowStack.swift
//  GitSetKit
//
//  Created by 최명근 on 2023/07/17.
//

import SwiftUI

struct FlowStack: View {
    @State private var contentHeight: CGFloat = .zero
    
    var contents: [Field] = []
    
    var body: some View {
        LazyVStack {
            GeometryReader { proxy in
                self.generateRows(geometryProxy: proxy, contents: contents)
            }
        }
    }
    
    func generateRows(geometryProxy g: GeometryProxy, contents: [Field]) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(self.contents, id: \.id) { content in
                self.item(for: content.wrappedName)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if content == self.contents.last! {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if content == self.contents.last! {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }.background(viewHeightReader($contentHeight))
    }
    
    private func item(for text: String) -> some View {
        Text(text)
            .padding(.all, 5)
            .font(.body)
            .background(Color.blue)
            .foregroundColor(Color.white)
            .cornerRadius(5)
    }
    
    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}
