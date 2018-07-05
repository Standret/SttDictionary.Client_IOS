//
//  SttViewPage.swift
//  YURT
//
//  Created by Standret on 12.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import UIKit

protocol SttViewPagerDelegate {
    func pageChanged(selectedIndex: Int, oldIndex: Int)
}

@IBDesignable
class SttViewPager: UIView, UIScrollViewDelegate {
    weak var parent: UIViewController!
    
    var selectedItem: Int = 0
    var heightTabBar: CGFloat!
    
    private var views = [(String, UIViewController)]()
    var segmentControl: UISegmentedControl!
    private var scrollView: UIScrollView!
    private var activeUnderline: UIView!
    private var underline: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        segmentControl = UISegmentedControl()
        scrollView = UIScrollView()
        underline = UIView()
        activeUnderline = UIView()
        
        segmentControl.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor(red:0.57, green:0.57, blue:0.57, alpha:1),
                                               NSAttributedStringKey.font: UIFont(name: "Roboto-Regular", size: 16)!], for: .normal)
        segmentControl.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor(named: "main")!,
                                               NSAttributedStringKey.font: UIFont(name: "Roboto-Bold", size: 16)!], for: .selected)
        segmentControl.addTarget(self, action: #selector(onValueChanged(_:)), for: .valueChanged)
        
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        
        addSubview(segmentControl)
        addSubview(scrollView)
        addSubview(underline)
        addSubview(activeUnderline)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        segmentControl.frame = CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: 44)
        segmentControl.selectedSegmentIndex = selectedItem
        segmentControl.removeBorders()
        
        scrollView.backgroundColor = UIColor.yellow
        scrollView.isUserInteractionEnabled = true
        scrollView.frame = CGRect(x: rect.minY, y: rect.minY + segmentControl.frame.height + 1, width: rect.width, height: rect.height - segmentControl.frame.height)
        
        print(segmentControl.frame.height)
        activeUnderline.frame = CGRect(x: 0, y: 43, width: rect.width / CGFloat(views.count), height: 2)
        activeUnderline.backgroundColor = UIColor(named: "main")
        
        underline.frame = CGRect(x: rect.minX, y: segmentControl.frame.height, width: rect.width, height: 1)
        underline.backgroundColor = UIColor(named: "borderLight")
        underline.setShadow(color: UIColor(named: "borderLight")!)
        
        insertInScrollView()
        redrawUnserline()
    }
    
    func addItem(view: UIViewController, title: String) {
        views.append((title, view))
    }
    
    private var isInitialize = false
    private func insertInScrollView() {
        if isInitialize {
            return
        }
        
        isInitialize = true
        scrollView.contentSize = CGSize(width: CGFloat(views.count) * scrollView.frame.width, height: scrollView.frame.height)
        print(scrollView.contentSize)
        
        var index = 0
        for item in views {
            item.1.view.frame = CGRect(x: CGFloat(index) * scrollView.frame.width, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            item.1.willMove(toParentViewController: parent)
            parent.addChildViewController(item.1)
            item.1.didMove(toParentViewController: parent)
            scrollView.addSubview(item.1.view)
            segmentControl.insertSegment(withTitle: item.0, at: index, animated: true)
            index += 1
        }
        segmentControl.selectedSegmentIndex = 0
    }

    
    private func redrawUnserline() {
        let normPosition = scrollView.contentOffset.x / CGFloat(views.count)
        activeUnderline.frame = CGRect(x: normPosition, y: 43, width: activeUnderline.frame.width, height: activeUnderline.frame.height)
    }
    
    @objc private func onValueChanged(_ sender: Any) {
        let position = scrollView.frame.width * CGFloat(segmentControl.selectedSegmentIndex)
        scrollView.setContentOffset(CGPoint(x: position, y: 0), animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        if page != segmentControl.selectedSegmentIndex {
            segmentControl.selectedSegmentIndex = page
            selectedItem = page
            // call about change view
        }
        redrawUnserline()
    }
}
