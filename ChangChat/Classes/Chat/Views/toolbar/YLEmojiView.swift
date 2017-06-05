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

    var datas = Array<YLEmojiModel>()
    
    lazy var collectionView : UICollectionView = {
        () -> UICollectionView in
        let layout = YLEmojiCollectionLayout()
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.register(YLEmojiCollectionCell.self, forCellWithReuseIdentifier: emojiCell)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .clear
        return cv
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(toolv.snp.top).offset(0)
        }
    }
    
    func loadEmoji() {
        let arr = YLEmojiModel.emoji()
        datas = datas + arr
        for key in arr {
            log.debug("info \(key.code!.emojiStr())")
            
        }
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
        cell.setEmojiImage(emojicodeStr: model.code!.emojiStr())
        return cell
    }
    
}


// MARK: /// YLEmojiCollectionLayout
class YLEmojiCollectionLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        self.scrollDirection = .horizontal
        self.itemSize = CGSize(width: 40, height: 40)
        self.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2)
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
        emojibtn.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
    }
    
    func setEmojiImage(emojicodeStr : String) {
        emojibtn.setTitle(emojicodeStr, for: .normal)
    }
}

class toolview: UIView {
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    convenience init(strings:[String]) {
        self.init()
        let scrollview = UIScrollView()
        scrollview.backgroundColor = .blue
        
        self.addSubview(scrollview)
        scrollview.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        for string in strings{
            let btn = UIButton()
            btn.backgroundColor = .red
            btn.setTitle(string, for: .normal)
            scrollview.addSubview(btn)
            if string == strings.last {
                btn.snp.makeConstraints({ (make) in
                    make.left.equalTo(60 * strings.index(of: string)! + 10)
                    make.top.equalTo(scrollview).offset(2)
                    make.bottom.equalTo(-2)
                    make.width.equalTo(50)
                    make.right.equalTo(0)
                })
            } else {
                btn.snp.makeConstraints({ (make) in
                    make.left.equalTo(60 * strings.index(of: string)! + 10)
                    make.top.equalTo(scrollview).offset(2)
                    make.bottom.equalTo(-2)
                    make.width.equalTo(50)
                })
            }
        }
        
    }
    
    
}