//
//  WorkFieldView.swift
//  GitSetKit
//
//  Created by Cho Chaewon on 2023/07/27.
//

import Foundation
import SwiftUI
import WrappingHStack

struct WorkFieldView: View {
    
    @Binding var selectedFields: [Field]
    @Binding var outputMessage: [String]
    @Binding var selectedFieldIndex: Int
    
    @State private var gitCommitOn = true
    @State private var commitMessage: String = "git commit -m \""
    
    var body: some View {
        VStack{
            ScrollView {
                WrappingHStack(Array(selectedFields.enumerated()), id: \.self, alignment: .leading, spacing: .constant(8), lineSpacing: 12) { index, block in
                    
                    if gitCommitOn && index == 0 {
                        Text(commitMessage)
                            .frame(width: 120)
                            .font(.custom("SourceCodePro-Light", size: 13))
                            .foregroundColor(.white)
                    }
                    
                    if block.type == 1 {
                        Text(block.wrappedName)
                            .foregroundColor(Color.white)
                            .fixedSize()

                    } else {
                        Button(action: {
                            selectedFieldIndex = index
                        }, label: {
                            Text(outputMessage[index])
                                .frame(maxWidth: 272)
                                .padding(.leading, 8)
                                .padding(.trailing, 8)
                                .foregroundColor(Color.white)
                                .truncationMode(.middle)
                        })
                        .fixedSize()
                        .lineLimit(nil)
                        .buttonStyle(.plain)
                        .frame(height: 18)
                        .background(Colors.Fill.codeBlockB)
                        .cornerRadius(4)
                        
                    }//else
                    
                    if index == (selectedFields.count-1) && gitCommitOn {
                        Text("\"")
                            .frame(width: 10)
                            .font(.custom("SourceCodePro-Light", size: 13))
                            .foregroundColor(.white)
                    }
                }//WrappingHStack
                .frame(width: 280, alignment: .center)
                .padding(12)
                .padding(.leading, 20)
                .padding(.trailing, 30)
                }//scrollView
            .frame(width: 280, height: 100, alignment: .center)
            
            HStack{
                VStack{
                    Divider()
                        .frame(width: 260, height: 1)
                        .background(Colors.Fill.codeBlockB)
                        .offset(x: 0, y: 12)
                    
                    Toggle(isOn: $gitCommitOn){
                        Text(" Git 명령어 포함")
                    }
                    .foregroundColor(Color.white)
                    .toggleStyle(.checkbox)
                    .offset(x: -80, y:15)
                }
                .frame(width: 260)
                
                Button(action: {
                    var combinedOutput = outputMessage.joined(separator: " ")
                    if gitCommitOn {
                        combinedOutput = commitMessage + combinedOutput + "\""
                    }
                    print(combinedOutput)
                    copyToPaste(text: combinedOutput)
                    print("복사됨")
                    
                }) {
                    ZStack{
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 32, height: 32)
                            .foregroundColor(.gray)
                        Image(systemName: "doc.on.doc")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.white)
                            .frame(width: 19, height: 18)
                    }
                }
                //.disabled(selectedFieldIndex != selectedFields.count - 1)
                .buttonStyle(.plain)
                .offset(x: 0, y: 10)
            }//HStack - copyAndPaste Button View
            .frame(width: 300, height: 20)
            .offset(x:0, y: -30)
            
        }//WorkFieldView
        .frame(maxWidth: 260)
    }
    
    //git commit message copied function
    func copyToPaste(text: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
    }
    
    
}
