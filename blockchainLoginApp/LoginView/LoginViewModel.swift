

import Foundation

protocol LoginViewModelProtocol: AnyObject {
    func login(password: String, name: String,completion: @escaping (Bool) -> Void)
}

class LoginViewModel: LoginViewModelProtocol {
    func login(password: String, name: String, completion: @escaping (Bool) -> Void) {
        networkManager.login(password: password, name: name, completion: completion)
    }
    
  
    
    let networkManager: NetworkServiceProtocol
    
    init(networkManager: NetworkServiceProtocol) {
        self.networkManager = networkManager
    }
}

