import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let settings = UIUserNotificationSettings(
            forTypes: UIUserNotificationType.Badge
            , categories: nil)
        application.registerUserNotificationSettings(settings);
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    // Watch kit app から呼び出しの場合
    func application(application: UIApplication
        ,handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?
        ,reply: (([NSObject : AnyObject]!) -> Void)!)
    {
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
        var vc:ViewController? = appDelegate.window?.rootViewController as? ViewController;
        
        if let info = userInfo as? [String: [String : Bool]] {
            if let boughtDic = info["bought"]
            {
                vc?.addBought(boughtDic.keys.first!, bought: boughtDic[boughtDic.keys.first!]!);
                vc?.buyTableView.reloadData();
            }
        }
        
        reply(["buylist": vc?.buyList as! AnyObject, "boughtlist": vc?.boughtList as! AnyObject]);

        // なんか遅いので処理も多くないしこれで
/*
        
        var bgTask: UIBackgroundTaskIdentifier!;
        bgTask = application.beginBackgroundTaskWithName("WatchTask", expirationHandler: { () -> Void in
            
            application.endBackgroundTask(bgTask);
            bgTask = UIBackgroundTaskInvalid;
        })
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
            var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
            var vc:ViewController? = appDelegate.window?.rootViewController as? ViewController;
            
            if let info = userInfo as? [String: [String : Bool]] {
                if let boughtDic = info["bought"]
                {
                    vc?.addBought(boughtDic.keys.first!, bought: boughtDic[boughtDic.keys.first!]!);
                    vc?.buyTableView.reloadData();
                }
            }
            
            reply(["buylist": vc?.buyList as! AnyObject, "boughtlist": vc?.boughtList as! AnyObject]);
            
            application.endBackgroundTask(bgTask);
            bgTask = UIBackgroundTaskInvalid;
        });
*/
        
    }
}

