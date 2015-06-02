//
//  GlanceController.swift
//  BuyMEMO WatchKit Extension
//
//  Created by 小笠原 大樹 on 2015/05/30.
//  Copyright (c) 2015年 ogataiki. All rights reserved.
//

import WatchKit
import Foundation


class GlanceController: WKInterfaceController {

    @IBOutlet weak var mainText: WKInterfaceLabel!
    
    var buyList: [String] = [];
    var boughtList: [String: Bool] = [:];

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        
        buyListUpdate();
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        buyListUpdate();
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    // 購入リストの更新
    func buyListUpdate()
    {
        //iPhone側の親アプリ呼び出し
        WKInterfaceController.openParentApplication([:],
            reply: {obj, error in
                
                self.buyList = obj["buylist"] as! [String];
                self.boughtList = obj["boughtlist"] as! [String: Bool];
                
                var textbuf: String = "";
                
                for(var i=0; i<self.buyList.count; ++i)
                {
                    textbuf += self.buyList[i];
                    textbuf += "\n";
                    
                    if(i > 1)
                    {
                        textbuf += "等 \(self.buyList.count)個";
                        break;
                    }
                }
                
                self.mainText.setText(textbuf);
        })
    }

}
