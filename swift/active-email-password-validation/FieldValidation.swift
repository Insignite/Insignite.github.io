//
//  ContentView.swift
//  YouTubeExampleProject
//
//  Created by Khanh Nguyen on 4/15/20.
//  Copyright © 2020 Just Code With Khanh. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var emailObj = EmailValidationObj()
    @ObservedObject var passObj = PasswordValidationObj()
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                 TextField("Email", text: $emailObj.email).foregroundColor(.white)
                 Text(emailObj.error).foregroundColor(.red).font(.caption)
            }
             
            VStack(alignment: .leading, spacing: 4) {
                TextField("Password", text: $passObj.pass).foregroundColor(.white)
                Text(passObj.error).foregroundColor(.red).font(.caption)
            }
        }
    }
}

struct ContentView_Previews : PreviewProvider {
    static var previews : some View {
        ContentView()
        
    }
}

class EmailValidationObj: ObservableObject {
    @Published var email = "" {
        didSet {
            if self.email.isEmpty {
                self.error = "Required"
            } else if !self.email.isValidEmail() {
                self.error = "Invalid email"
            } else {
                self.error = ""
            }
        }
    }
    
    @Published var error = ""
}

class PasswordValidationObj: ObservableObject {
    @Published var pass = "" {
        didSet {
            self.isValidPassword()
        }
    }
    
    @Published var error = ""
    
    private func isValidPassword() {
        guard !self.pass.isEmpty else {
            self.error = "Required"
            return
        }
        
        let setPassError = self.pass.isPassword() == false
        
        if setPassError {
            if self.pass.count < 6 {
                self.error = "Must be at least 6 characters"
            } else if !self.pass.isUpperCase() {
                self.error = "Must contain at least one uppercase."
            } else if !self.pass.isLowerCase() {
                self.error = "Must contain at least one lowercase"
            } else if !self.pass.containsCharacter() {
                self.error = "Must contain at least one special character"
            } else if !self.pass.containsDigit() {
                self.error = "Must contain at least one digit"
            }
        } else {
            self.error = ""
        }
    }
}

extension String {
    // TODO: Test cases
    func isValidEmail() -> Bool {
        let emailRegEx = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}"
            + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
            + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
            + "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
            + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
            + "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
            + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"

        let emailValidation = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailValidation.evaluate(with: self)
    }
    
    func isPassword() -> Bool {
        let passwordRegex = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<]{6,}$"
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        return passwordPred.evaluate(with: self)
    }
    
    func isUpperCase() -> Bool {
        let uppercaseReqRegex = ".*[A-Z]+.*"
        return NSPredicate(format:"SELF MATCHES %@", uppercaseReqRegex).evaluate(with: self)
    }
    
    func isLowerCase() -> Bool {
        let lowercaseReqRegex = ".*[a-z]+.*"
        return NSPredicate(format:"SELF MATCHES %@", lowercaseReqRegex).evaluate(with: self)
    }
    
    func containsCharacter() -> Bool {
        let characterReqRegex = ".*[!@#$%^&*()\\-_=+{}|?>.<]+.*"
        return NSPredicate(format:"SELF MATCHES %@", characterReqRegex).evaluate(with: self)
    }
    
    func containsDigit() -> Bool {
        let digitReqRegex = ".*[0-9]+.*"
        return NSPredicate(format:"SELF MATCHES %@", digitReqRegex).evaluate(with: self)
    }
}
