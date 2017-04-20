//
//  update.swift
//  iosCheckNGO
//
//  Created by Minwoo Park on 3/27/17.
//  Copyright © 2017 Ignite. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
