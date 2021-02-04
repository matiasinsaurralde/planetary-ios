//
//  JoinOperation.swift
//  Planetary
//
//  Created by Martin Dutra on 2/4/21.
//  Copyright © 2021 Verse Communications Inc. All rights reserved.
//

import Foundation

/// This will generate a secret and login into gobot
class JoinOperation: AsynchronousOperation {
    
    var birthdate: Date
    var username: String
    
    private(set) var result: Result<Onboarding.Context, Error>?
    
    init(birthdate: Date, username: String) {
        self.birthdate = birthdate
        self.username = username
        super.init()
    }
     
    override func main() {
        let phone = "800-555-1212"
        Onboarding.start(birthdate: birthdate, phone: phone, name: username) { [weak self] context, error in
            Log.optional(error)
            CrashReporting.shared.reportIfNeeded(error: error)
            if let context = context {
                self?.result = .success(context)
            } else if let error = error {
                self?.result = .failure(error)
            } else {
                self?.result = .failure(AppError.unexpected)
            }
            self?.finish()
        }
     }
    
}
