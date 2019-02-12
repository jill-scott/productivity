//
//  StateManager+EventHandling.swift
//  Chorganizer
//
//  Created by Jill Scott on 8/19/18.
//  Copyright © 2018 Jill. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - Event Handling

extension StateManager {
    
    func processEvent(event: StateEvent) { // swiftlint:disable:this cyclomatic_complexity
        switch event {
        case .addTeammate(let team, let teammate):
            try! realm.write {
                // Update teammate in case we have update info
                realm.add(teammate, update: true)
                
                // Only add the teammate if we don't already have one of the same name
                if team.teammates.first(where: { $0.name == teammate.name }) == nil {
                    team.teammates.append(teammate)
                }
            }
        case .updateTeammate(let teammate):
            try! realm.write {
                //Update teammate in case we have update info
                realm.add(teammate, update: true)
            }
        case .addTeam(let team):
            try! realm.write {
                // Update team in case we have update info
                realm.add(team, update: true)
                
                // Only add the team if we don't have one of the same name
                if let appData = StateManager.sharedInstance.getAppData() {
                    if appData.allTeams.first(where: { $0.name == team.name }) == nil {
                        appData.allTeams.append(team)
                    }
                }
            }
        case .initializeAppData():
            try! realm.write {
                if StateManager.sharedInstance.getAppData() == nil {
                    realm.add(AppData())
                }
            }
        }
            
            //        case .addSystem(let system):
            //            if let user = currentUser {
            //                try! realm.write {
            //                    // Update the system in case any updated info came back from the server.
            //                    realm.add(system, update: true)
            //
            //                    // Only add the system to the user if we don't have it in our list already.
            //                    if user.systems.first(where: { $0.id == system.id }) == nil {
            //                        user.systems.append(system)
            //                    }
            //                }
            //            }
            
//        case .loggedIn(let user):
//            if let email = user.email {
//                StateManager.sharedInstance.replaceEmailForLastLoginData(email: email)
//            }
//            do {
//                try realm.write {
//                    realm.add(user, update: true)
//                }
//            } catch {
//                debugPrint("Error when adding user: \(error)")
//            }
//            #if DEBUG
//                // If we haven't started up the socket router, do so if we found out we have an infinity device in our list.
//                if user.systems.first(where: { $0.type == .infinity }) != nil && socketRouter == nil {
//                    initalizeSocketRouter()
//                }
//            #endif
//
//        case .loggedOut:
//            let userEmail = realm.objects(LastLoginData.self).first?.loginEmail
//            do {
//                try realm.write {
//                    realm.deleteAll()
//                }
//            } catch {
//                debugPrint("Problem Deleting Realm Data: \(error)")
//            }
//
//            // Reset our app config so we aren't attempting to access a deleted object after this.
//            appConfig.value = AppConfig()
//            if let email = userEmail {
//                StateManager.sharedInstance.replaceEmailForLastLoginData(email: email)
//            }
//
//            #if DEBUG
//                privateSocketRouter?.eventHandler = nil
//                privateSocketRouter?.disconnect()
//                privateSocketRouter = nil
//            #endif
//
//        case .fetchedSystems(let systems):
//            if let user = currentUser {
//                #if DEBUG
//                    let systemsToAdd = systems
//                #else
//                    let systemsToAdd = systems.filter({ $0.type != .infinity })
//                #endif
//                try! realm.write {
//                    systemsToAdd.forEach({ (system) in
//                        realm.add(system, update: true)
//                    })
//                    user.systems.removeAll()
//                    user.systems.append(objectsIn: systemsToAdd)
//                }
//
//                #if DEBUG
//                    // If we haven't started up the socket router, do so if we found out we have an infinity device in our list.
//                    if user.systems.first(where: { $0.type == .infinity }) != nil && socketRouter == nil {
//                        self.initalizeSocketRouter()
//                    }
//                #endif
//            }
//
//        case .addSystem(let system):
//            if let user = currentUser {
//                try! realm.write {
//                    // Update the system in case any updated info came back from the server.
//                    realm.add(system, update: true)
//
//                    // Only add the system to the user if we don't have it in our list already.
//                    if user.systems.first(where: { $0.id == system.id }) == nil {
//                        user.systems.append(system)
//                    }
//                }
//            }
//
//            #if DEBUG
//                // We need to tell the socket server that we have a new device if it's an Infinity system.
//                if system.type == .infinity {
//                    // If we haven't started up the socket router, do so if we found out we have an infinity device in our list.
//                    if self.socketRouter == nil {
//                        self.initalizeSocketRouter()
//                    }
//                }
//            #endif
//
//        case .saveDelayedSystemToAdd(let system):
//            if let user = currentUser {
//                try! realm.write {
//                    if getMetaSystem(system: system) != nil {
//                        realm.add(system, update: true)
//                    }
//                    let sys = user.systemsToAdd.first(where: { $0.serialNumber == system.serialNumber })
//                    if sys == nil {
//                        user.systemsToAdd.append(system)
//                    }
//                }
//            }
//
//        case .deleteDelayedSystemToAdd(let system):
//            if let user = currentUser {
//                guard let sys = user.systemsToAdd.first(where: { $0.serialNumber == system.serialNumber }) else { return }
//                guard let index = user.systemsToAdd.index(of: sys) else { return }
//                try! realm.write {
//                    user.systemsToAdd.remove(at: index)
//                    realm.delete(system)
//                }
//            }
//
//        case .saveDelayedSystemToClaimPrimary(let system):
//            if let user = currentUser {
//                if user.systemsToClaimPrimary.first(where: { $0.serialNumber == system.serialNumber }) != nil { return }
//                try! realm.write {
//                    user.systemsToClaimPrimary.append(system)
//                }
//            }
//
//        case .deleteDelayedSystemToClaimPrimary(let system):
//            if let user = currentUser {
//                guard let sys = user.systemsToClaimPrimary.first(where: { $0.serialNumber == system.serialNumber }) else { return }
//                guard let index = user.systemsToClaimPrimary.index(of: sys) else { return }
//                try! realm.write {
//                    user.systemsToClaimPrimary.remove(at: index)
//                    realm.delete(system)
//                }
//            }
//
//        case .viewSystem(let system):
//            systemData.value = nil
//            iQ20SystemData.value = nil
//            i2dRobotSystemData.value = nil
//            privateSystem = system
//            if let user = currentUser, let systemCurr = currentSystem {
//                try! realm.write {
//                    user.serialNumberAccessed = systemCurr.serialNumber
//                    debugPrint("Successfully wrote to realm")
//                }
//            }
//            if let system = system {
//                getSystemDetails(system: system)
//                viewedSystem(system: system)
//            } else {
//                #if DEBUG
//                    disconnectBleRouter()
//                #endif
//            }
//
//        case .directConnect(let system, let btDevice):
//            if system != nil {
//                privateSystem = system
//            }
//            #if DEBUG
//                if btDevice != nil {
//                    bleRouter = btDevice
//                    initializeBleRouter()
//                }
//            #endif
//
//        case .systemFirmwareIsUpdating(let system, let updating):
//            try! realm.write {
//                system.updating = updating
//            }
//
//        case .suppressZodiacMessage(let id):
//            if let user = currentUser {
//                if user.zodiacMessagesSuppressed.contains(id) == false {
//                    try! realm.write {
//                        user.zodiacMessagesSuppressed.append(id)
//                    }
//                }
//            }
//        }
//    }
//
//    #if DEBUG
//    internal func socketEventHandler(event: SocketEvent, json: JSON?) {
//        switch event {
//        case .connected:
//            debugPrint("Infinity Client has recieved a connected event")
//            StatusBarNotificationBanner.dismissWithTag(.socketRouterDisconnected)
//        case .ready:
//            debugPrint("Infinity Client is now ready to interact with")
//            StatusBarNotificationBanner.dismissWithTag(.socketRouterDisconnected)
//        case .response:
//            debugPrint("Infinity Client recieved response!")
//            handleCCP(json: json?["rp"])
//        case .error:
//            debugPrint("Infinity Client recieved an error!")
//            showSocketServerDisconnected()
//        case .disconnect:
//            debugPrint("Infinity Client disconnected")
//            showSocketServerDisconnected()
//        case .unknown:
//            assertionFailure("We should never recieve an unknown event")
//        }
//    }
//
//    internal func showSocketServerDisconnected() {
//        let banner = StatusBarNotificationBanner(title: "Disconnected from Socket Server", style: .danger)
//        banner.autoDismiss = false
//        banner.onTap = { [weak self] in
//            self?.socketRouter?.connect()
//        }
//        banner.onSwipeUp = { [weak self] in
//            self?.socketRouter?.connect()
//        }
//        banner.showWithTag(.socketRouterDisconnected)
//    }
//
//    /// The action to take if our response packet matches the JSON we are checking for.
//    ///
//    /// - sn: Serial Number if any that this response pertains to
//    /// - json: The response data in JSON form
//    typealias OneOffAction = (_ sn: String?, _ json: JSON) -> Void
//
//    /// Used to define special functionality for handling responses from the socket server or BLE
//    ///
//    /// - json: A subset of an incoming response that this being looked for
//    /// - action: The action is run if `json` is a subset of the incoming packet
//    /// - continue: A Bool that determines if parsing should continue if the action is run.
//    typealias OneOffHandler = (json: JSON, action: OneOffAction?, continue: Bool)
//
//    /// Use to provide special functionality for specific response packets
//    ///
//    /// - Returns: An array of special functionality to handle data outside of All Data Modifications
//    internal func oneOffHandlers() -> [OneOffHandler] {
//        // All Data Handler
//        let adJSON = JSON(["t": "if", "a": "ad"])
//        // When we recieve an All Data message, pull the status in case it's an updated value.
//        let adAction: OneOffAction = { [weak self] (sn, json) in
//            // All data can come in via multiple packets now, make sure we aren't reverting our status.
//            if json[Infinity.AllData.Keys.status].exists() {
//                self?.systemStatus.value[sn ?? ""] = Infinity.Status(json[Infinity.AllData.Keys.status])
//            }
//        }
//
//        // System Status Handler
//        let ssJSON = JSON(["t": "if", "a": "sv"])
//        let ssAction: OneOffAction = { [weak self] (sn, json) in
//            self?.systemStatus.value[sn ?? ""] = Infinity.Status(json)
//        }
//
//        // Device disconnect handler
//        let ddJSON = JSON(["t": "if", "a": "dc"])
//        let ddAction: OneOffAction = { [weak self] (sn, json) in
//            self?.systemStatus.value[sn ?? ""] = Infinity.Status(status: .uninitialized)
//            if self?.currentSystem?.serialNumber == sn {
//                self?.systemData.value?.status = .uninitialized
//                // Force a change notification to be sent for the all data object since we changed a sub-variable.
//                self?.systemData.value = self?.systemData.value
//            }
//        }
//
//        // WIFI Access Points
//        let apJSON = JSON(["t": "wi", "a": "sl"])
//        let apAction: OneOffAction = { [weak self] (sn, json) in
//            // The Infinity systems will return multiple access points for the same network.
//            // We want to filter out the furthest duplicates from our list.
//            var uniqueAPs = Set<String>()
//            self?.apList.value = json.arrayValue.map({ (apJSON) -> Infinity.WifiAP in
//                return Infinity.WifiAP(apJSON)
//            }).sorted(by: { (leftAP, rightAP) -> Bool in
//                // Sort our Access Points by signal strength, closer to 0 means better signal.
//                // Default to 0 signal if we can't parse our rssi.
//                return Int(leftAP.rssi) ?? -100 > Int(rightAP.rssi) ?? -100
//            }).filter({ (ap) -> Bool in
//                if !uniqueAPs.contains(ap.ssid) {
//                    uniqueAPs.insert(ap.ssid)
//                    return true
//                }
//                return false
//            })
//        }
//
//        // Start Up Message
//        let suJSON = JSON(["t": "if", "a": "st"])
//        let suAction: OneOffAction = { [weak self] (sn, json) in
//            guard let systems = self?.currentUser?.systems else { return }
//            guard let system = systems.first(where: { $0.serialNumber == sn }) else { return }
//
//            let startUp = Infinity.StartUp(json)
//            // We currently only respond to firmware update, but we could add other notifications like reconnect, pending Zodiac approval
//            if startUp.reason == .firmwareUpdate {
//                self?.processEvent(event: .systemFirmwareIsUpdating(system, false))
//                let banner = StatusBarNotificationBanner(title: "\(system.name) Updated Firmware Succeded", style: .success)
//                banner.show()
//            }
//        }
//
//        // Firmware Update Message
//        let fuJSON = JSON(["t": "if", "a": "dl"])
//        let fuAction: OneOffAction = { [weak self] (sn, json) in
//            guard let systems = self?.currentUser?.systems else { return }
//            guard let system = systems.first(where: { $0.serialNumber == sn }) else { return }
//
//            let updateInfo = Infinity.FirmwareUpdate(json)
//            if let error = updateInfo.downloadError {
//                // Since there was a download error, make sure to set the system to not updating.
//                self?.processEvent(event: .systemFirmwareIsUpdating(system, false))
//                let title = "\(system.name) Failed to Update Firmware"
//                let banner = StatusBarNotificationBanner(title: "\(title) \(error.reason)", style: .danger)
//                banner.show()
//            } else {
//                self?.processEvent(event: .systemFirmwareIsUpdating(system, updateInfo.downloadState == .downloading))
//            }
//        }
//
//        // Multiple Packet Message
//        let mpJSON = JSON(["t": "mv", "a": "ad"])
//        let mpAction: OneOffAction = { [weak self] (sn, json) in
//            // Make sure this multiple packet is for this system.
//            if let sn = sn, sn == self?.currentSystem?.serialNumber {
//                // For each sub-packet within this one, run it through our "handleCCP" function as we would do if it was a single.
//                json.arrayValue.forEach({ self?.handleCCP(json: JSON(["rp": $0, "id": sn])) })
//            }
//        }
//
//        return [
//            // Continue parsing in case we are looking for this All Data object.
//            (adJSON, adAction, true),
//            // We want the parsing to continue because we will want to update our all data object if the serial number matches
//            (ssJSON, ssAction, true),
//            (apJSON, apAction, false),
//            (suJSON, suAction, false),
//            (fuJSON, fuAction, false),
//            (mpJSON, mpAction, false),
//            (ddJSON, ddAction, false)
//        ]
//    }
//
//    internal func handleCCP(json: JSON?) {
//        // If we don't have any data to operate on, just return.
//        guard let json = json, json["rp"].exists() else { return }
//
//        // Grab the main portion of our response and serial number that this response pertains to.
//        let packet = json["rp"]
//        let packetNum = json["pn"].intValue
//        let serialNumber = json["id"].string
//
//        // Grab our timestamp that we use as packet IDs, check to see if we are looking for a response to this.
//        if let packetID = json["sq"].string, let response = self.bannerResponses[AppBannerTag(rawValue: packetID)] {
//            // Determine if we recieved an error for our request.
//            if packet["e"].exists() {
//                let subtitle = Infinity.Error(fromRawValue: packet["e"].stringValue).description
//                let banner = StatusBarNotificationBanner(title: response + " failed with error: " + subtitle, style: .danger)
//                banner.show()
//                return      // Return if we recieved an error, don't try and update data.
//            } else {
//                let banner = StatusBarNotificationBanner(title: response + " succeeded!", style: .success)
//                banner.duration = 0.5
//                banner.show()
//            }
//        }
//
//        // Check to see if we have a packet that has special case handling
//        for handler in oneOffHandlers() {
//            if handler.json.isSubset(of: packet) {
//                handler.action?(serialNumber, packet["v"])
//
//                if !handler.continue {
//                    return
//                }
//            }
//        }
//
//        // Check to see if this packet is about our current system.
//        if currentSystem?.serialNumber == serialNumber {
//            let target = packet["t"].stringValue
//            let attribute = packet["a"].stringValue
//            let operation = packet["o"].stringValue
//            let value = packet["v"]
//
//            switch target {
//            case "if":
//                // Only attribute currently we need to special case is "ad" which is the entire All Data value.
//                if attribute == "ad" {
//                    if systemData.value != nil {
//                        systemData.value?.packetIndecies.insert(packetNum)
//                        systemData.value?.update(with: value)
//                        // Force a change notification to be sent for the all data object since we changed a sub-variable.
//                        systemData.value = systemData.value
//                    } else {
//                        systemDataFetchTime = Date()
//                        systemData.value = Infinity.AllData(value)
//                        systemData.value?.packetIndecies.insert(packetNum)
//                    }
//                } else {
//                    // If it's any other Infinity attribute, flatten it as if it was coming in like the full All Data value.
//                    systemData.value?.update(with: JSON([attribute: value]))
//                    // Force a change notification to be sent for the all data object since we changed a sub-variable.
//                    systemData.value = systemData.value
//                }
//            default:
//                // Check to make sure it's not a delete or add function
//                // If that's true, run the packet's v object through our "updateWithTarget:" function on all data.
//                // If it's a delete action, run it through "removeDeviceForTarget"
//                // If it's an add, can we run it through the same updateWithTarget function?... See....if we can, if not add an "addDeviceWithTarget" function.
//                if operation == Infinity.Packet.Operation.delete.rawValue {
//                    systemData.value?.deleteTarget(target, with: value)
//                } else {
//                    systemData.value?.updateTarget(target, with: value)
//                }
//                // Force a change notification to be sent for the all data object since we changed a sub-variable.
//                systemData.value = systemData.value
//            }
//        }
//    }
//    #endif
}
}
