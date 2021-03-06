//
//  YLEmojiView.swift
//  ChangChat
//
//  Created by 魏延龙 on 2017/6/2.
//  Copyright © 2017年 wyl. All rights reserved.
//

import UIKit

let emojiCell = "emojiCell"
class YLEmojiView: UIView ,UICollectionViewDelegate,UICollectionViewDataSource{

    public func emojiclick(_ closure: (_ title: String) -> Void) {
    }
    //回调函数 (_ closure: (_ make: ConstraintMaker) -> Void)
    var emojiclick : ((_ title : String) -> Void)?
    
    var datas = Array<YLEmojiModel>()
    lazy var collectionView : UICollectionView = {
        () -> UICollectionView in
        let layout = YLEmojiCollectionLayout()
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.register(YLEmojiCollectionCell.self, forCellWithReuseIdentifier: emojiCell)
        cv.delegate = self
        cv.dataSource = self
        cv.isPagingEnabled = true
        cv.backgroundColor = .clear
        return cv
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.lightGray
        loadUI()
        loadEmoji()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadUI() {
        let toolv = toolview(strings: ["kiss","open","kiss1","open1","kiss2","open2","kiss3","open3","kiss4","open4","kiss5","open5"])
        self.addSubview(toolv)
        toolv.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(0)
            make.height.equalTo(44)
        }
        
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(10)
            make.bottom.equalTo(toolv.snp.top).offset(-15)
        }
    }
    
    func loadEmoji() {
        let arr = YLEmojiModel.emoji()
        datas = datas + arr
        for key in arr {
            if arr.index(of: key)! != 0 && (arr.index(of: key)! + 1) % 24 == 0 {
                let dic = ["code":"删","type":"0"]
                let emoModel = YLEmojiModel(dic: dic)
                datas.insert(emoModel, at: arr.index(of: key)!)
            }
            log.debug("info \(key.code!.emojiStr())")
            
        }
        let dic = ["code":"删","type":"0"]
        let emoModel = YLEmojiModel(dic: dic)
        datas.append(emoModel)
    }

    
    // MARK: UICollectionViewDelegate,UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emojiCell, for: indexPath) as! YLEmojiCollectionCell
        let model = datas[indexPath.item]
        if model.type == "0" {
            cell.setEmojiImage(emojicodeStr: model.code!)
        } else {
            cell.setEmojiImage(emojicodeStr: model.code!.emojiStr())
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let emojiModel = datas[indexPath.item];
        if emojiclick != nil {
            emojiclick!((emojiModel.code?.emojiStr())!)
        }
    }
    
    deinit {
        log.debug("ylemojiview 释放")
    }
    
}


// MARK: /// YLEmojiCollectionLayout
class YLEmojiCollectionLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        self.scrollDirection = .horizontal
        self.itemSize = CGSize(width: 50, height: 50)
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.minimumLineSpacing = 2
        self.minimumInteritemSpacing = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: /// YLEmojiCollectionCell
class YLEmojiCollectionCell:UICollectionViewCell {
    
    var emojibtn = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func loadUI() {
        self.contentView.addSubview(emojibtn)
        emojibtn.isEnabled = false
        emojibtn.setTitleColor(.black, for: .normal)
        emojibtn.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
    }
    
    func setEmojiImage(emojicodeStr : String) {
        emojibtn.setTitle(emojicodeStr, for: .normal)
    }
}

// MARK: 最底部的工具栏
class toolview: UIView {

    let settingBtn = UIButton()
    let changeBtn = UIButton()
    
    convenience init(strings:[String]) {
        self.init()
        let addbtn = UIButton()
        addbtn.setTitle("add", for: .normal)
        addbtn.backgroundColor = .red
        self.addSubview(addbtn)
        addbtn.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.height.equalTo(self)
            make.centerY.equalTo(self)
            make.width.equalTo(60)
        }
        
        settingBtn.setTitle("sett", for: .normal)
        settingBtn.backgroundColor = .orange
        self.addSubview(settingBtn)
        settingBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self)
            make.height.centerY.equalTo(self)
            make.width.equalTo(60)
        }
        
        changeBtn.setTitle("send", for: .normal)
        changeBtn.backgroundColor = .red
        self.addSubview(changeBtn)
        changeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self)
            make.height.centerY.equalTo(self)
            make.width.equalTo(60)
        }
        
        let scrollview = UIScrollView()
        scrollview.backgroundColor = .blue
        self.addSubview(scrollview)
        scrollview.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(60)
            make.right.equalTo(-60)
        }
        for string in strings{
            let btn = UIButton()
            btn.tag = strings.index(of: string)! + 10
            btn.backgroundColor = .red
            btn.setTitle(string, for: .normal)
            scrollview.addSubview(btn)
            scrollview.showsHorizontalScrollIndicator = false
            if string == strings.last {
                btn.snp.makeConstraints({ (make) in
                    make.left.equalTo(CGFloat(60 * strings.index(of: string)!))
                    make.height.equalTo(self)
                    make.centerY.equalTo(self)
                    make.width.equalTo(50)
                    make.right.equalTo(-60)
                })
            } else {
                btn.snp.makeConstraints({ (make) in
                    make.left.equalTo(CGFloat(60 * strings.index(of: string)!))
                    make.height.equalTo(self)
                    make.centerY.equalTo(self)
                    make.width.equalTo(50)
                })
            }
            btn.addTarget(self, action: #selector(scrollBtnClick(sender:)), for: .touchUpInside)
        }
        
    }
    
    func scrollBtnClick(sender : UIButton) {
        //tag = index + 10
        if sender.tag == 10 {
            UIView.animate(withDuration: 0.5, animations: { 
                self.changeBtn.snp.updateConstraints({ (make) in
                    make.width.equalTo(60)
                })
                self.settingBtn.snp.updateConstraints({ (make) in
                    make.width.equalTo(0)
                })
                self.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: { 
                self.changeBtn.snp.updateConstraints({ (make) in
                    make.width.equalTo(0)
                })
                self.settingBtn.snp.updateConstraints({ (make) in
                    make.width.equalTo(60)
                })
                self.layoutIfNeeded()
            })
        }
    }
    
    deinit {
        log.debug("toolview 释放")
    }
    
}
