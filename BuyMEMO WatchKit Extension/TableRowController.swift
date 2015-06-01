import UIKit
import WatchKit

class TableRowController: NSObject {
    
    @IBOutlet weak var BuyItem: WKInterfaceSwitch!
    
    var bought: Bool = false;
    
    @IBAction func TapSwitch(value: Bool) {
        // スイッチ切り替えた
        bought = value;
    }    
}