////
////  WatchSessionManager.swift
////
//import WatchConnectivity
//
//class WatchSessionManager: NSObject, WCSessionDelegate {
//    func sessionDidBecomeInactive(_ session: WCSession) {
//        
//    }
//    
//    func sessionDidDeactivate(_ session: WCSession) {
//        
//    }
//    
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
//        
//    }
//    
//    
//    static let sharedManager = WatchSessionManager()
//    
//    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
//    private var validSession: WCSession? {
//        if let session = session, session.isPaired && session.isWatchAppInstalled {
//            return session
//        }
//        return nil
//    }
//    
//    var shelter: Bool
//    
//    func startSessionWithShelter(shelter: Bool) {
//        self.shelter = shelter
//        session?.delegate = self
//        session?.activate()
//        
//        if shelter == true {
//            updateApplicationContext()
//        }
//    }
//    
//    func sessionWatchStateDidChange(_ session: WCSession) {
//        if session.activationState == .activated {
//            updateApplicationContext()
//        }
//    }
//    
//    // Construct and send the updated application context to the watch.
//    func updateApplicationContext() {
//        let context = [String: AnyObject]()
//        
//        // Now, compute the values from your model object to send to the watch.
//        do {
//            try WatchSessionManager.sharedManager.updateApplicationContext(applicationContext: context)
//        } catch {
//            print("Error updating application context")
//        }
//    }
//    
//}
//
//// MARK: Application Context
//extension WatchSessionManager {
//    
//    // Sender
//    func updateApplicationContext(applicationContext: [String : AnyObject]) throws {
//        if let session = validSession {
//            do {
//                try session.updateApplicationContext(applicationContext)
//            } catch let error {
//                throw error
//            }
//        }
//    }
//    
//}
//
//
//// MARK: Interactive Messaging
//extension WatchSessionManager {
//    
//    private var validReachableSession: WCSession? {
//        if let session = validSession, session.isReachable {
//            return session
//        }
//        return nil
//    }
//    
//    // Receiver
//    func session(session: WCSession, didReceiveMessage message: [String : AnyObject],
//                 replyHandler: ([String : AnyObject]) -> Void) {
//        
//    }
//    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
//        
//    }
//    
//}
