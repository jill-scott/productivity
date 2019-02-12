//
//  StateManager.swift
//  Chorganizer
//
//  Created by Jill Scott on 8/19/18.
//  Copyright © 2018 Jill. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

enum StateEvent {
    case addTeam(Team)
    case addTeammate(Team, Teammate)
    case updateTeammate(Teammate)
    case initializeAppData()
}

class StateManager {
    
    static let sharedInstance = StateManager()
    
    // This prevents others from using the default '()' initializer for this class.
    private init() {
        RealmMigration.performRealmMigration()
        
        do {
            try self.realm = Realm()
        } catch {
            debugPrint("Unable to initalize Realm!  Fatal Error!")
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    
    // MARK: - Properties
    internal let realm: Realm
    
    var firstTeam: Team? {
        return self.realm.objects(Team.self).first
    }
    
    var teammates: List<Teammate>? {
        return getTeammatesForTeam(teamName: firstTeam?.name ?? "")
    }
    
    func getAppData() -> AppData? {
        return realm.objects(AppData.self).first
    }
    
    func getTeammatesForTeam(teamName: String) -> List<Teammate>? {
        let team = realm.objects(Team.self).first(where: { $0.name == teamName })
        return team?.teammates
    }
    
    //    func getMetaSystem(system: System) -> System? {
    //        return realm.objects(System.self).filter("serialNumber == \"\(system.serialNumber)\"").first
    //    }
    
    
    
//    var currentUser: User? { return self.realm.objects(User.self).first }
//
//    internal var privateSystem: System?
//    var currentSystem: System? { return self.privateSystem }
//
//    // App config
//    lazy var appConfig: Variable<AppConfig> = {
//        // Return latest version we have or default config.
//        let config = self.realm.objects(AppConfig.self).sorted(byKeyPath: "version", ascending: false).first ?? AppConfig()
//        return Variable(config)
//    }()
//    private let configPublishSubject = PublishSubject<Any?>()
//    private let messagePublishSubject = PublishSubject<Any?>()
//
//    #if DEBUG
//    // Below router is used for all infinity connections
//    internal var privateSocketRouter: SocketRouter?
//    var socketRouter: SocketRouter? { return self.privateSocketRouter }
//
//    internal var bleRouter: InfinityBLEDevice?
//    internal var bleMsgSubscription: Disposable?
//    #endif
//
//    // Device status
//    let systemStatus: Variable<[String: SystemStatusProtocol]> = Variable([:])
//    let askedForStatus: Variable<Set<String>> = Variable([])
    
    // Device data
    
//    let systemData: Variable<Infinity.AllData?> = Variable(nil)
//    let iQ20SystemData: Variable<iQ20.HomeStatus?> = Variable(nil)
//    let i2dRobotSystemData: Variable<i2dRobot.CleanerStatus?> = Variable(nil)
//    let i2dPumpSystemData: Variable<i2dPump.Status?> = Variable(nil)
//    var systemDataFetchTime: Date?
//    let apList: Variable<[Infinity.WifiAP]?> = Variable(nil)
    
    // Notification Banners
//    var banners: [Int: StatusBarNotificationBanner] = [:]
//    var bannerResponses: [AppBannerTag: String] = [:]
    
    let disposeBag = DisposeBag()
}

//extension StateManager {
//    
//    func getSystemStatus(system: System) {
//        // Make sure we don't have the status already, or we are currently trying to fetch.
//        // This prevents duplicate requests from going out.
//        guard let user = self.currentUser, askedForStatus.value.contains(system.serialNumber) == false else { return }
//        
//        // Infinity is a special case, we ask for all of our statuses at once instead of one at a time.
//        if system.type == .infinity {
//            InfinityRemoteClient.getAllSystemStatus(user: user) { [weak self] (result) in
//                // Ensure we haven't logged out between the time we asked for status and the return of it.
//                guard user.isInvalidated == false else { return }
//                
//                switch result {
//                case .failure(let error):
//                    debugPrint("Error fetching Infinity System Status: \(error)")
//                    // Loop through and set all of our infinity systems to offline.
//                    for aSys in user.systems where aSys.type == .infinity {
//                        self?.systemStatus.value[aSys.serialNumber] = Infinity.Status(status: .uninitialized)
//                    }
//                case .success(let dictionary):
//                    for aSys in user.systems where aSys.type == .infinity {
//                        self?.systemStatus.value[aSys.serialNumber] = dictionary[aSys.serialNumber] ?? Infinity.Status(status: .uninitialized)
//                    }
//                }
//            }
//            
//            // Make sure to set all of our statuses to updating if we have asked.
//            for aSys in user.systems where aSys.type == .infinity {
//                askedForStatus.value.insert(aSys.serialNumber)
//            }
//        } else {
//            // Make sure we have a client
//            guard let client = system.client() else { return }
//            
//            do {
//                try client.getSystemStatus(system: system, user: user, handler: { [weak self] (result) in
//                    // Ensure we haven't logged out between the time we asked for status and the return of it.
//                    guard user.isInvalidated == false else { return }
//                    
//                    switch result {
//                    case .success(let status):
//                        self?.systemStatus.value[system.serialNumber] = status
//                    case .failure:
//                        // If our system failed, just assign an uninitalized value to an InfinityStatus, which results in a red dot for this system.
//                        self?.systemStatus.value[system.serialNumber] = Infinity.Status(status: .uninitialized)
//                    }
//                })
//                
//                // Let our my systems page know that we are currently fetching this systems information.
//                // This will prevent us asking multiple times as well.
//                askedForStatus.value.insert(system.serialNumber)
//            } catch {
//                debugPrint("Failed to get status for system: ", system, error.localizedDescription)
//            }
//        }
//    }
//    
//    func getSystemDetails(system: System) {
//        switch system.type {
//        case .infinity:
//            InfinityClient.getSystemData(system: system, ({ (sent) in
//                if !sent {
//                    debugPrint("Failed to get status for Infinity: ", system.serialNumber)
//                }
//            }, nil))
//        case .iaqua:
//            AqualinkRemoteClient.getSystemStatus(system: system, user: currentUser!, handler: { [weak self] (result) in
//                switch result {
//                case .success(let status):
//                    self?.iQ20SystemData.value = (status as! iQ20.HomeStatus)
//                case .failure:
//                    self?.iQ20SystemData.value = nil
//                }
//            })
//        case .i2drobot:
//            // Since we have all of the information about this robot already, pass it on through, otherwise go and fetch it.
//            if let status = systemStatus.value[system.serialNumber] as? i2dRobot.CleanerStatus {
//                i2dRobotSystemData.value = status
//            } else {
//                system.remoteRobotClient.getSystemStatus { [weak self] (result) in
//                    switch result {
//                    case .success(let status):
//                        if let status = status as? i2dRobot.CleanerStatus {
//                            self?.i2dRobotSystemData.value = status
//                        }
//                    case .failure:
//                        self?.i2dRobotSystemData.value = nil
//                    }
//                }
//            }
//        case .i2dpump:
//            if let status = systemStatus.value[system.serialNumber] as? i2dPump.Status {
//                i2dPumpSystemData.value = status
//            } else {
//                system.remotei2dPumpClient.getSystemStatus { [weak self] (result) in
//                    switch result {
//                    case .success(let status):
//                        if let status = status as? i2dPump.Status {
//                            self?.i2dPumpSystemData.value = status
//                        }
//                    case .failure:
//                        self?.i2dPumpSystemData.value = nil
//                    }
//                }
//            }
//        default:
//            return
//        }
//    }
//    
//    func getEmailForLastLoginData() -> String {
//        let lastLoginData = realm.objects(LastLoginData.self).first ?? LastLoginData()
//        return lastLoginData.loginEmail
//    }
//    
//    func replaceEmailForLastLoginData(email: String) {
//        let lastLoginData = realm.objects(LastLoginData.self).first ?? LastLoginData()
//        guard lastLoginData.loginEmail != email else { return }
//        // If the saved login email is different from the currently logged in email, replace it
//        do {
//            try realm.write {
//                lastLoginData.loginEmail = email
//                realm.add(lastLoginData, update: true)
//                debugPrint("Wrote to realm successfully!")
//            }
//        } catch {
//            debugPrint("Error when saving login data: \(error)")
//        }
//    }
//    
//    func getMetaSystem(system: System) -> System? {
//        return realm.objects(System.self).filter("serialNumber == \"\(system.serialNumber)\"").first
//    }
//    
//    func getExistingMetaDataForSystem(system: System) -> SystemAppData? {
//        return realm.objects(SystemAppData.self).filter("serialNumber == \"\(system.serialNumber)\"").first
//    }
//    
//    func getMetaDataForSystem(appVersion: String, system: System) -> SystemAppData {
//        return getExistingMetaDataForSystem(system: system) ?? writeEmptyVersionData(appVersion: appVersion, system: system)
//    }
//    
//    func getMetaVersionDataForSystem(appVersion: String, system: System) -> AppVersionValues {
//        let metaData = getMetaDataForSystem(appVersion: appVersion, system: system)
//        guard let versData = metaData.versionValues.filter({ $0.appVersion == appVersion }).first else {
//            let newVersion = AppVersionValues(av: appVersion)
//            try! realm.write {
//                metaData.versionValues.append(newVersion)
//                realm.add(metaData, update: true)
//            }
//            return newVersion
//        }
//        return versData
//    }
//    
//    func writeEmptyVersionData(appVersion: String, system: System) -> SystemAppData {
//        let metaData = SystemAppData(sn: system.serialNumber, av: appVersion)
//        try! realm.write {
//            realm.add(metaData, update: true)
//        }
//        return metaData
//    }
//    
//    func hasUserAgreedToRobotWarning(appVersion: String, system: System) -> Bool {
//        let versionData = getMetaVersionDataForSystem(appVersion: appVersion, system: system)
//        return versionData.hasAgreedToRobotCompliance
//    }
//    
//    func agreeToRobotWarning(appVersion: String, system: System) {
//        let metaData = getMetaDataForSystem(appVersion: appVersion, system: system)
//        let versionData = getMetaVersionDataForSystem(appVersion: appVersion, system: system)
//        try! realm.write {
//            versionData.hasAgreedToRobotCompliance = true
//            // Add/update the meta data for this system.
//            realm.add(metaData, update: true)
//        }
//    }
//    
//    func getCleanerLifeTipShown(appVersion: String, system: System, screen: Int) -> Bool {
//        let metaData = getMetaDataForSystem(appVersion: appVersion, system: system)
//        let versionData = getMetaVersionDataForSystem(appVersion: appVersion, system: system)
//        switch screen {
//        case SystemAppData.ScreenForInfoTips.homeScreen.rawValue:
//            let screenDisplays = versionData.homeShowCleanerLifeTip
//            if screenDisplays == 10 {
//                try! realm.write {
//                    //Add/update the meta data for this system.
//                    realm.add(metaData, update: true)
//                }
//                return true
//            }
//            
//            try! realm.write {
//                versionData.homeShowCleanerLifeTip += 1
//                //Add/update the meta data for this system.
//                realm.add(metaData, update: true)
//            }
//            return false
//            
//        case SystemAppData.ScreenForInfoTips.scheduleScreen.rawValue:
//            let screenDisplays = versionData.scheduleShowCleanerLifeTip
//            if screenDisplays == 10 {
//                return true
//            }
//            
//            try! realm.write {
//                versionData.scheduleShowCleanerLifeTip += 1
//                //Add/update the meta data for this system.
//                realm.add(metaData, update: true)
//            }
//            return false
//        default:
//            return false
//        }
//    }
//    
//    func dismissCleanerLifeTip(appVersion: String, system: System, screen: Int) {
//        let metaData = getMetaDataForSystem(appVersion: appVersion, system: system)
//        let versionData = getMetaVersionDataForSystem(appVersion: appVersion, system: system)
//        switch screen {
//        case SystemAppData.ScreenForInfoTips.homeScreen.rawValue:
//            try! realm.write {
//                versionData.homeShowCleanerLifeTip = 0
//                //Add/update the meta data for this system.
//                realm.add(metaData, update: true)
//            }
//        case SystemAppData.ScreenForInfoTips.scheduleScreen.rawValue:
//            try! realm.write {
//                versionData.scheduleShowCleanerLifeTip = 0
//                //Add/update the meta data for this system.
//                realm.add(metaData, update: true)
//            }
//        default:
//            break
//        }
//    }
//    
//    func viewedSystem(system: System) {
//        guard let version = Bundle.main.releaseVersionNumber else {
//            return
//        }
//        let versionData = getMetaVersionDataForSystem(appVersion: version, system: system)
//        try! realm.write {
//            versionData.systemViewCount += 1
//        }
//    }
//    
//    func systemViewCount() -> Int {
//        guard let version = Bundle.main.releaseVersionNumber else {
//            return 0
//        }
//        return realm.objects(AppVersionValues.self)
//            .filter("appVersion = '\(version)' AND ratedApp = false")
//            .sum(ofProperty: "systemViewCount")
//    }
//    
//    func hasRated() -> Bool {
//        guard let version = Bundle.main.releaseVersionNumber else {
//            return true
//        }
//        
//        return realm.objects(AppVersionValues.self).first(where: { $0.appVersion == version && $0.ratedApp }) != nil
//    }
//    
//    func didRate() {
//        try? realm.write {
//            realm.objects(AppVersionValues.self).forEach({
//                $0.ratedApp = true
//            })
//        }
//    }
//    
//    func updateAppConfig() {
//        configPublishSubject.onNext(nil)
//    }
//    
//    func fetchMessage() {
//        messagePublishSubject.onNext(nil)
//    }
//    
//    func refreshUsersSession() {
//        guard let user = currentUser, let sessionId = user.sessionId else { return }
//        
//        let userId = String(describing: user.id)
//        APIClient.refreshSession(userId: userId, sessionId: sessionId).drive(onNext: { [weak self] (result) in
//            switch result {
//            case .success:
//                debugPrint("Refreshed session successfully")
//            case .failure(let error):
//                switch error {
//                case BackendError.api(let apiError):
//                    if apiError.status == 401 {
//                        self?.processEvent(event: .loggedOut())
//                        let delegate = UIApplication.shared.delegate as! AppDelegate
//                        delegate.checkForUser()
//                    }
//                default:
//                    debugPrint("Failed to refresh session with error: \(error)")
//                }
//            }
//        }).disposed(by: disposeBag)
//    }
//}

