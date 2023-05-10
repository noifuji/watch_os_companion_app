//
//  ContentView.swift
//


import SwiftUI
import WatchConnectivity
import AVFoundation


struct ContentView: View {
    
    @ObservedObject var connector = PhoneConnector()
    
    var body: some View {
        VStack {
            VStack {
                
                Text(String(connector.counter))
                    .font(.largeTitle)
                    .foregroundColor(Color.gray)
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class PhoneConnector: NSObject, ObservableObject, WCSessionDelegate {
    @Published var counter = 0
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            
            WCSession.default.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith state= \(activationState.rawValue)")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("didReceiveMessage: \(message)")
        
        //受け取ったメッセージから解析結果を取り出す。
        let result = message["COUNTER"] as! String
        
        if let c = Int(result) {
            //結果を画面に反映
            debugPrint(c)
            DispatchQueue.main.async {
                self.counter = c
            }
        }
        
    }
}
