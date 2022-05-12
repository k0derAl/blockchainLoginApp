

import Foundation


class UserSettings {
    
    
    static var token: String {
        get {
            UserDefaults.standard.string(forKey: #function) ?? ""
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: #function)
        }
    }
}
