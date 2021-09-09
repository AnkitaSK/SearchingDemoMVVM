//
//  Bindable.swift
//  SearchingMVVM
//
//  Created by Ankita on 09.09.21.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            // closure is called
            observer?(value)
        }
    }
    
    var observer: ((T?) ->())?
    
    // this will be used to bind viewModel later
    // closure is initialized here
    func bind(observer: @escaping ((T?) -> ())) {
        self.observer = observer
    }
}
