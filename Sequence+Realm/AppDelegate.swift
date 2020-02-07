//
//  AppDelegate.swift
//  Sequence+Realm
//
//  Created by Ihor Mostoviy on 04.02.2020.
//  Copyright © 2020 Ihor Mostoviy. All rights reserved.
//

import UIKit
import KeychainSwift
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        checkKey()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        return true
    }

    private func checkKey() {
        let isInMemory = "\(Bundle.main.object(forInfoDictionaryKey: "IN_MEMORY")!)" == "YES"
        guard !isInMemory else {
            let config = Realm.Configuration(inMemoryIdentifier: "InMemory")
            Realm.Configuration.defaultConfiguration = config
            return
        }

        let keychain = KeychainSwift()
        if let key = keychain.getData("key") {
            let configuation = Realm.Configuration(encryptionKey: key)
            Realm.Configuration.defaultConfiguration = configuation
            return
        }

        var key = Data(count: 64)
        _ = key.withUnsafeMutableBytes { bytes in
            SecRandomCopyBytes(kSecRandomDefault, 64, bytes)
        }
        keychain.set(key, forKey: "key")
        let configuation = Realm.Configuration(encryptionKey: key)
        Realm.Configuration.defaultConfiguration = configuation
    }
}

