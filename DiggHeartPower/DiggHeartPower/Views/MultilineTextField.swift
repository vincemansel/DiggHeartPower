//
//  MultilineTextField.swift
//  DiggHeartPower
//
//  Created by Vince Mansel on 8/31/21.
//
// from:
//  MultilineTextField.swift
//  ControlViewProject
//
//  Created by Vince Mansel on 2/4/21.
//

import SwiftUI
import UIKit

struct MultilineTextField: UIViewRepresentable {
    
    @Binding var text: String
    var backgroundColor: UIColor
    var isEditable: Bool
    
    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        
        view.font = UIFont.systemFont(ofSize: 15)
        view.backgroundColor = backgroundColor
        view.isScrollEnabled = true
        view.isEditable = isEditable
        view.isUserInteractionEnabled = true
        view.text = text
        view.delegate = context.coordinator
      
        view.layoutManager.allowsNonContiguousLayout = false

        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        textViewScrollToBottom(uiView)
    }
  
    private func textViewScrollToBottom(_ uiView: UITextView) {
      let stringLength:Int = uiView.attributedText.string.count
      uiView.scrollRangeToVisible(NSMakeRange(stringLength-1, 0))
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        
        var parent: MultilineTextField
        
        init(_ uiTextView: MultilineTextField) {
            self.parent = uiTextView
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
}


