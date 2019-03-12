import Foundation
import Capacitor
import IntentsUI

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitor.ionicframework.com/docs/plugins/ios
 */
@objc(SiriShortcutsPlugin)
class SiriShortcutsPlugin: CAPPlugin {
    
    public let kActivityType = Bundle.main.bundleIdentifier!
    public let kEventname = "appLaunchBySirishortcuts"
    public var call: CAPPluginCall!
    
    override func load() {
        // add listeners here
        NotificationCenter.default.addObserver(self, selector: #selector(self.onOpenAppByUserActivity(notification:)),
                                               name: Notification.Name(CAPNotifications.ContinueActivity.name()), object: nil)
    }
    
    @objc func donate(_ call: CAPPluginCall) {
        if #available(iOS 12.0, *) {
            guard let activity = self.makeActivity(call) else { return }
            self.call = call
            self.launchActivity(activity)
        } else {
            call.reject(SiriError.version.description)
        }
    }
    
    @objc func removeAll(_ call: CAPPluginCall) {
        if #available(iOS 12.0, *) {
            NSUserActivity.deleteAllSavedUserActivities {
                call.resolve()
            }
        } else {
            call.reject(SiriError.version.description)
        }
    }
    
    @objc func remove(_ call: CAPPluginCall) {
        if #available(iOS 12.0, *) {
            guard let identifiers = call.getArray("identifiers", String.self) else {
                call.reject(SiriError.input.description)
                return
            }
            
            let persistentIdentifiers: [NSUserActivityPersistentIdentifier] = identifiers.map { (identifier) -> String in
                NSUserActivityPersistentIdentifier("\(kActivityType).\(identifier)")
            }
            NSUserActivity.deleteSavedUserActivities(withPersistentIdentifiers: persistentIdentifiers) {
                call.resolve()
            }
        } else {
            call.reject(SiriError.version.description)
        }
    }
}


@available(iOS 12.0, *)
extension SiriShortcutsPlugin: INUIAddVoiceShortcutViewControllerDelegate {
    
    fileprivate func makeActivity(_ call: CAPPluginCall) -> NSUserActivity? {
        guard let persistentIdentifier = call.getString("persistentIdentifier"),
            let title = call.getString("title"),
            let isEligibleForSearch = call.getBool("isEligibleForSearch", true),
            let isEligibleForPrediction = call.getBool("isEligibleForPrediction", true),
            let userInfo = call.getObject("userInfo", defaultValue: [:]),
            let suggestedInvocationPhrase = call.getString("suggestedInvocationPhrase", title)
            else { return nil }
        
        let activity = NSUserActivity(activityType: kActivityType)
        activity.title = title
        activity.userInfo = userInfo
        activity.persistentIdentifier = NSUserActivityPersistentIdentifier("\(kActivityType).\(persistentIdentifier)")
        activity.suggestedInvocationPhrase = suggestedInvocationPhrase
        activity.isEligibleForPrediction = isEligibleForPrediction
        activity.isEligibleForSearch = isEligibleForSearch
        
        return activity
    }
    
    fileprivate func launchActivity(_ activity: NSUserActivity) -> Void {
        let shortcut = INShortcut(userActivity: activity)
        let vc = INUIAddVoiceShortcutViewController(shortcut: shortcut)
        vc.delegate = self
        DispatchQueue.main.async { [weak self] in
            self?.bridge.viewController.present(vc, animated: true, completion: nil)
        }
    }
    
    func addVoiceShortcutViewController( _ controller: INUIAddVoiceShortcutViewController,
                                         didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        self.bridge.viewController.dismiss(animated: true, completion: { [weak self] in
            if error == nil {
                self?.call.resolve()
            } else {
                self?.call.reject(SiriError.error.description)
            }
            self?.call = nil
        })
    }
    
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        self.bridge.viewController.dismiss(animated: true, completion: { [weak self] in
            self?.call.reject(SiriError.cancel.description)
            self?.call = nil
        })
    }
    
}

extension SiriShortcutsPlugin {
    
    @objc fileprivate func onOpenAppByUserActivity(notification: Notification) {
        self.notifyListeners(kEventname, data: notification.object as? [String : Any] ?? [:], retainUntilConsumed: true)
    }
}

enum SiriError: String {
    case input = "invalid arguments"
    case version = "not supported"
    case cancel = "user opted for cancel"
    case error = "siri error"
}

extension SiriError: CustomStringConvertible {
    var description: String {
        return self.rawValue
    }
}