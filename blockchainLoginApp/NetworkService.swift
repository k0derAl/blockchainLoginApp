

import Foundation
import Starscream

protocol NetworkServiceProtocol: AnyObject {
    func login(password: String, name: String,completion: @escaping (Bool) -> Void)
    func subscribeUnTransactions()
    func unSubscribeUnTransactions()
}

class NetworkService {
    var socket: WebSocket?
    private enum Urls {
        static let baseUrl = "https://dev.karta.com/api"
        static let auth = "/accounts/auth"
    }
    
}

extension NetworkService: NetworkServiceProtocol {
    func unSubscribeUnTransactions() {
        guard let socket = socket else { return }
        if let params1 = "{\"op\":\"unconfirmed_unsub\"}".data(using: .utf8) {
            socket.write(data: params1)
        }
    }
    
    
    func subscribeUnTransactions() {
        let url = URL(string: "wss://ws.blockchain.info/inv")!
        let request = URLRequest(url: url)
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
        
    }
    
    func login(password: String, name: String,completion: @escaping (Bool) -> Void) {
        let url = URL(string: Urls.baseUrl + Urls.auth)
        
        guard let url = url else {
            return
        }
        
        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData
        )
        
        let tsName = name == "" ? "hello@karta.com" : name
        let tsPassword = password == "" ? "12345678" : password
        
        let params = "{\"email\":\"\(tsName)\",\"password\":\"\(tsPassword)\"}".data(using: .utf8)

        
       request.httpMethod = "POST"
       request.httpBody = params
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                completion(false)
            }
            
            if let data = data {
                let str = String(decoding: data, as: UTF8.self)
                
                do {
                    let model = try JSONDecoder().decode(TokenModel.self, from: data)
                    UserSettings.token = model.token
                   
                    self.subscribeUnTransactions()
                    completion(true)
                } catch let error {
                    print(error)
                }
                
                
                
                print(str)
                
            }
        }
        
        task.resume()
    }
}

extension NetworkService: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected( _):
            if let params1 = "{\"op\":\"unconfirmed_sub\"}".data(using: .utf8) {
                client.write(ping: params1)
            }
           
        case .disconnected(let reason, let closeCode):
            print("disconnected \(reason) \(closeCode)")
        case .text(let text):
            print("received text: \(text)")
        case .binary(let data):
            print("received data: \(data)")
        case .pong(let pongData):
            if let pongData = pongData {
                let str = String(decoding: pongData, as: UTF8.self)
                print("received pong: \(str)")
            }
        case .ping(let pingData):
            print("received ping: \(pingData!)")
        case .error(let error):
            print("error \(error!)")
        case .viabilityChanged:
            print("viabilityChanged")
        case .reconnectSuggested:
            print("reconnectSuggested")
        case .cancelled:
            print("cancelled")
        }
    }
}

struct TokenModel: Codable {
    let token: String
    let expiration: String
    let serverTime: String
    
    enum CodingKeys: String, CodingKey {
        case token
        case expiration
        case serverTime = "server_time"
    }
}
