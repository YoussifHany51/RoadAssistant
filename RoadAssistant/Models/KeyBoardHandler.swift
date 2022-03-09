//
//  KeyBoardHandler.swift
//  RoadAssistant
//
//  Created by Youssif Hany on 05/03/2022.
//

import Combine
import SwiftUI

final class KeyBoardHandler: ObservableObject{
    
    @Published private(set) var keyBoardHeight: CGFloat = 0
    
    private var cancellable: AnyCancellable?
    
    private let keyBoardShow = NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillShowNotification)
        .compactMap{ ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height }
    
    private let keyBoardHide = NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillHideNotification)
        .map{ _ in CGFloat.zero}
    
    init(){
        cancellable = Publishers.Merge(keyBoardShow,keyBoardHide)
            .subscribe(on: DispatchQueue.main)
            .assign(to: \.self.keyBoardHeight, on: self)
    }
}
