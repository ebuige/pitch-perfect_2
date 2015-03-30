//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Troutslayer33 on 3/23/15.
//  Copyright (c) 2015 Troutslayer33. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    
    var filePathUrl: NSURL!
    var title: String!
    init(filePathUrl: NSURL , title: String ){
        self.filePathUrl = filePathUrl
        self.title = title
        
    }
    
}