import UIKit
import GoogleMobileAds

class ViewController: UIViewController
    , UITableViewDelegate
    , UITableViewDataSource
    , TableCellDelegate
{
    @IBOutlet weak var buyTableView: UITableView!
    
    @IBOutlet weak var gadBannerView: GADBannerView!
    
    var buyList: [String] = [];
    var boughtList: [String: Bool] = [:];
    
    enum BUYITEM_EDITMODE: Int {
        case add = 0, edit
    }
    struct EDITBUYITEM {
        var buyItemEditMode: BUYITEM_EDITMODE;
        var editIndex: Int;
    }
    var editBuyItem = EDITBUYITEM(buyItemEditMode: BUYITEM_EDITMODE.add, editIndex: 0);
    
    let buyListSaveKey = "buylist";
    let boughtListSaveKey = "bought";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 買うものリスト
        if((NSUserDefaults.standardUserDefaults().objectForKey(buyListSaveKey)) != nil){
            if var arr = NSUserDefaults.standardUserDefaults().objectForKey(buyListSaveKey) as? [String]
            {
                // 読み込みOK
                buyList = arr;
            }
            else
            {
                buyList = [];
            }
        }
        // 買ったものリストの購入済みフラグ
        if((NSUserDefaults.standardUserDefaults().objectForKey(boughtListSaveKey)) != nil){
            if var arr = NSUserDefaults.standardUserDefaults().objectForKey(boughtListSaveKey) as? [String: Bool]
            {
                // 読み込みOK
                boughtList = arr;
            }
            else
            {
                boughtList = [:];
            }
        }
        
        buyTableView.delegate = self;
        buyTableView.dataSource = self;
        //buyTableView.registerClass(TableCell.self, forCellReuseIdentifier: "BuyItem")
        
        
        // AdMob呼び出し
        gadBannerView.adUnitID = "ca-app-pub-0000000000000000/0000000000";
        gadBannerView.rootViewController = self;
        let gadRequest = GADRequest();
        gadRequest.testDevices = ["f53f84138559f6ef12ec2126ee863bbd"];
        gadBannerView.loadRequest(gadRequest)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addBuyItemInputView(text: String = "")
    {
        var textAlert = UIAlertController(title: "買うものを入力"
            , message: ""
            , preferredStyle: UIAlertControllerStyle.Alert);
        
        textAlert.addTextFieldWithConfigurationHandler { (tf: UITextField!) -> Void in
            tf.placeholder = "買うもの";
            tf.text = text;
        };
        
        let defaultAction:UIAlertAction = UIAlertAction(title: "決定",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction!) -> Void in
                
                var textField = textAlert.textFields?.first as! UITextField;
                if(self.editBuyItem.buyItemEditMode == BUYITEM_EDITMODE.edit)
                {
                    self.buyList[self.editBuyItem.editIndex] = textField.text;
                }
                else
                {
                    self.buyList.append(textField.text);
                }
                
                NSUserDefaults.standardUserDefaults().setObject(self.buyList, forKey:self.buyListSaveKey);
                NSUserDefaults.standardUserDefaults().synchronize();

                // 購入済み状態を初期化
                self.boughtList[textField.text] = false;
                NSUserDefaults.standardUserDefaults().setObject(self.boughtList, forKey:self.boughtListSaveKey);
                NSUserDefaults.standardUserDefaults().synchronize();

                self.buyTableView.reloadData();
        })
        
        let cancelAction:UIAlertAction = UIAlertAction(title: "やめる",
            style: UIAlertActionStyle.Cancel,
            handler:{
                (action:UIAlertAction!) -> Void in
        })
        
        textAlert.addAction(defaultAction);
        textAlert.addAction(cancelAction);
        
        presentViewController(textAlert, animated: true, completion: nil);
    }

    @IBAction func addBuyItem(sender: UIBarButtonItem) {
        
        editBuyItem.buyItemEditMode = BUYITEM_EDITMODE.add;
        editBuyItem.editIndex = 0;
        addBuyItemInputView();
        
    }
    
    @IBAction func resetList(sender: AnyObject) {
        buyList.removeAll(keepCapacity: false);
        buyTableView.reloadData();
        
        NSUserDefaults.standardUserDefaults().setObject(self.buyList, forKey:self.buyListSaveKey);
        NSUserDefaults.standardUserDefaults().synchronize();
    }
    
    func addBought(item: String, bought: Bool)
    {
        boughtList[item] = bought;
        NSUserDefaults.standardUserDefaults().setObject(self.boughtList, forKey:self.boughtListSaveKey);
        NSUserDefaults.standardUserDefaults().synchronize();
    }
    
    func resetBought()
    {
        boughtList.removeAll(keepCapacity: false);
        NSUserDefaults.standardUserDefaults().setObject(self.boughtList, forKey:self.boughtListSaveKey);
        NSUserDefaults.standardUserDefaults().synchronize();
    }
    
    func changeSwitch(key: String, value: Bool) -> Void
    {
        addBought(key, bought: value);
        buyTableView.reloadData();
    }

    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return buyList.count + 1;
    }
    
    // Cellが選択された際に呼び出される.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.row == buyList.count)
        {
            editBuyItem.buyItemEditMode = BUYITEM_EDITMODE.add;
            editBuyItem.editIndex = 0;
            addBuyItemInputView();
        }
        else
        {
            editBuyItem.buyItemEditMode = BUYITEM_EDITMODE.edit;
            editBuyItem.editIndex = indexPath.row;
            addBuyItemInputView(text: "\(buyList[indexPath.row])");
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
    }
    
    // Cellに値を設定する
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("BuyItem", forIndexPath: indexPath) as! TableCell;
        
        cell.setDelegate(self);
        
        // Cellに値を設定.
        if(indexPath.row == buyList.count)
        {
            cell.setTitle("【タップして買うものを追加】");
            cell.invalidSwitch(true);
        }
        else
        {
            cell.setTitle("\(buyList[indexPath.row])");
            cell.invalidSwitch(false);
            if let bought = boughtList[buyList[indexPath.row]]
            {
                cell.setSwitch(bought);
            }
            else
            {
                cell.setSwitch(false);
            }
        }
        
        return cell;
    }
    
    // Cellを挿入または削除しようとした際に呼び出される
    func tableView(tableView: UITableView
        , commitEditingStyle editingStyle: UITableViewCellEditingStyle
        , forRowAtIndexPath indexPath: NSIndexPath)
    {
        // 削除のとき.
        if editingStyle == UITableViewCellEditingStyle.Delete
        {
            if(indexPath.row < buyList.count)
            {
                boughtList[buyList[indexPath.row]] = nil;
                NSUserDefaults.standardUserDefaults().setObject(self.boughtList, forKey:self.boughtListSaveKey);
                NSUserDefaults.standardUserDefaults().synchronize();

                buyList.removeAtIndex(indexPath.row);
                NSUserDefaults.standardUserDefaults().setObject(self.buyList, forKey:self.buyListSaveKey);
                NSUserDefaults.standardUserDefaults().synchronize();

                buyTableView.reloadData()
            }
        }
    }
    
}

