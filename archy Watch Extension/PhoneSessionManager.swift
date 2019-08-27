//import WatchConnectivity
//
//class PhoneSessionManager: NSObject, WCSessionDelegate {
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
//        
//    }
//    
//    
//    static let sharedManager = PhoneSessionManager()
//    
//    // Reference to the model object.
////    private var shelterSummary = ShelterSummary()
//    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
//    
//    func startSession() {
//        session?.delegate = self
//        session?.activate()
//    }
//    
//    func requestApplicationContext() {
//        // Send a message with a key that your phone expects. You can organize your constants in a
//        // series of structs like I did, or hard code a string instead of Key.Request.ApplicationContext.
//        sendMessage([ApplictionCon: true], replyHandler: nil, errorHandler: nil)
//    }
//    
//    func sessionReachabilityDidChange(session: WCSession) {
//        // Request new application context when reachability changes.
//        requestApplicationContext()
//    }
//    
//}
//
//// MARK: Application Context
//extension PhoneSessionManager {
//    
//    // Receiver
//    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
//        dispatch_async(dispatch_get_main_queue()) { [weak self] in
//            // Update the model object.
//            self?.shelterSummary.updateFromContext(applicationContext)
//        }
//    }
//    
//}
//
//
//// MARK: Interactive Messaging
//extension PhoneSessionManager {
//    
//    // App has to be reachable for live messaging.
//    private var validReachableSession: WCSession? {
//        if let session = session, session.isReachable {
//            return session
//        }
//        return nil
//    }
//    
//    // Sender
//    func sendMessage(message: [String : AnyObject], replyHandler: (([String : AnyObject]) -> Void)? = nil,
//                     errorHandler: ((NSError) -> Void)? = nil) {
//        validReachableSession?.sendMessage(message, replyHandler: replyHandler as! ([String : Any]) -> Void, errorHandler: errorHandler as! (Error) -> Void)
//    }
//    
//}
