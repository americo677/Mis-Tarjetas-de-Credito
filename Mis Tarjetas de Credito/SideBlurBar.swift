//
//  SideBlurBar.swift
//  SideBlurBar
//
//  Created by Américo Cantillo on 7/02/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import UIKit

@objc protocol SideBlurBarDelegate {
    func sideBlurBarDidSelectMenuOption(indexPath: NSIndexPath)
    @objc optional func sideBlurBarWillClose()
    @objc optional func sideBlurBarWillOpen()
}

class SideBlurBar: NSObject, SideBarViewControllerDelegate {

    let sideBlurBarTableViewTopInset: CGFloat = 64.0
    let sideBlurBarContainerView: UIView = UIView()
    let sideBlurBarViewController = SideBarTableViewController()
    var originView: UIView!
    
    var barWidth: CGFloat = 150.0
    var animator: UIDynamicAnimator!
    var delegate: SideBlurBarDelegate?
    var isSideBlurBarOpen: Bool = false
    
    //var isVisible: Bool = true
    
    override init() {
        super.init()
    }

    init(sourceView: UIView, menuWidth: CGFloat, sections: Array<String>, options:Array<Array<String>>) {
        super.init()
        originView = sourceView
        sideBlurBarViewController.delegate = self
        sideBlurBarViewController.options = options
        sideBlurBarViewController.sections = sections
        barWidth = menuWidth
        
        setupSideBlurBar()
        
        animator = UIDynamicAnimator(referenceView: originView)
        
        let showGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(recognizer:)))
        showGestureRecognizer.direction = UISwipeGestureRecognizerDirection.right
        originView.addGestureRecognizer(showGestureRecognizer)
        
        let hideGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(recognizer:)))
        hideGestureRecognizer.direction = UISwipeGestureRecognizerDirection.left
        originView.addGestureRecognizer(hideGestureRecognizer)
        
        let hideTapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        
        hideTapGestureRecognizer.numberOfTapsRequired = 1
        hideTapGestureRecognizer.numberOfTouchesRequired = 1
        hideTapGestureRecognizer.cancelsTouchesInView = false
        originView.addGestureRecognizer(hideTapGestureRecognizer)
    }
    
    init(sourceView: UIView, menuWidth: CGFloat, sections: Array<String>, options:Array<Array<String>>, images:Array<Array<String>>) {
        super.init()
        originView = sourceView
        sideBlurBarViewController.delegate = self
        sideBlurBarViewController.options = options
        sideBlurBarViewController.sections = sections
        sideBlurBarViewController.images = images
        barWidth = menuWidth
        
        setupSideBlurBar()
        
        animator = UIDynamicAnimator(referenceView: originView)
        
        let showGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(recognizer:)))
        showGestureRecognizer.direction = UISwipeGestureRecognizerDirection.right
        originView.addGestureRecognizer(showGestureRecognizer)
        
        let hideGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(recognizer:)))
        hideGestureRecognizer.direction = UISwipeGestureRecognizerDirection.left
        originView.addGestureRecognizer(hideGestureRecognizer)
        
        let hideTapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        
        hideTapGestureRecognizer.numberOfTapsRequired = 1
        hideTapGestureRecognizer.numberOfTouchesRequired = 1
        hideTapGestureRecognizer.cancelsTouchesInView = false
        originView.addGestureRecognizer(hideTapGestureRecognizer)
    }

    func setupSideBlurBar() {
        
        // esta linea no funciona para self.automaticallyAdjustsScrollViewInsets = true
        //sideBlurBarContainerView.frame = CGRect(x: -barWidth - 1, y: originView.frame.origin.y, width: barWidth, height: originView.frame.size.height)
        
        sideBlurBarContainerView.frame = CGRect(x: -barWidth - 1, y: -64, width: barWidth, height: originView.frame.size.height)

        
        
        
        sideBlurBarContainerView.backgroundColor = UIColor.clear
        sideBlurBarContainerView.clipsToBounds = false
        
        originView.addSubview(sideBlurBarContainerView)
        
        let blurView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurView.frame = sideBlurBarContainerView.bounds
        sideBlurBarContainerView.addSubview(blurView)
    
        sideBlurBarViewController.delegate = self
        sideBlurBarViewController.tableView.frame = sideBlurBarContainerView.bounds
        sideBlurBarViewController.tableView.clipsToBounds = false
        sideBlurBarViewController.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        sideBlurBarViewController.tableView.backgroundColor = UIColor.clear
        sideBlurBarViewController.tableView.scrollsToTop = false

        
        
        //sideBlurBarViewController.tableView.scrollsToTop = true
        
        
        
        
        sideBlurBarViewController.tableView.contentInset  = UIEdgeInsetsMake(sideBlurBarTableViewTopInset, 0.0, 0.0, 0.0)
        
        sideBlurBarViewController.tableView.reloadData()
        
        sideBlurBarContainerView.addSubview(sideBlurBarViewController.tableView)
    
    }
    
    @objc func handleSwipe(recognizer: UISwipeGestureRecognizer) {
        if recognizer.direction == .left {
            showSideBlurBar(shouldOpen: false)
            delegate?.sideBlurBarWillClose?()
        } else {
            showSideBlurBar(shouldOpen: true)
            delegate?.sideBlurBarWillOpen?()
        }
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        if recognizer.location(in: originView).x > barWidth {
            showSideBlurBar(shouldOpen: false)
            delegate?.sideBlurBarWillClose?()
        }
    }
    
    func showSideBlurBar(shouldOpen: Bool) {
        animator.removeAllBehaviors()
        isSideBlurBarOpen = shouldOpen
        
        let gravityX: CGFloat = (shouldOpen) ? 0.5 : -0.5
        let magnitud: CGFloat = (shouldOpen) ? 10 : -10
        let boundaryX: CGFloat = (shouldOpen) ? barWidth : -barWidth - 1
        
        let gravityBehavior: UIGravityBehavior = UIGravityBehavior(items: [sideBlurBarContainerView])
        gravityBehavior.gravityDirection = CGVector(dx: gravityX, dy:0)
        
        animator.addBehavior(gravityBehavior)
        
        let collisionBehavior: UICollisionBehavior = UICollisionBehavior(items: [sideBlurBarContainerView])
        
        collisionBehavior.addBoundary(withIdentifier: "sideBlurBarBoundary" as NSCopying, from: CGPoint(x: boundaryX, y: 20), to: CGPoint(x: boundaryX, y: originView.frame.size.height))

        animator.addBehavior(collisionBehavior)
        
        let pushBehavior: UIPushBehavior = UIPushBehavior(items: [sideBlurBarContainerView], mode:UIPushBehaviorMode.instantaneous)
        
        pushBehavior.magnitude = magnitud
        animator.addBehavior(pushBehavior)
        
        let sideBlurBarBehavior: UIDynamicItemBehavior = UIDynamicItemBehavior(items: [sideBlurBarContainerView])
        sideBlurBarBehavior.elasticity = 0.3
        animator.addBehavior(sideBlurBarBehavior)
    }
    
    func sideBarControlDidSelectRowAt(indexPath: NSIndexPath) {
        delegate?.sideBlurBarDidSelectMenuOption(indexPath: indexPath)
        showSideBlurBar(shouldOpen: false)
    }
    
    func hideSideBlurBar() {
        //sideBlurBarContainerView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        //sideBlurBarContainerView.backgroundColor = UIColor.clear
        //sideBlurBarContainerView.clipsToBounds = false
        sideBlurBarContainerView.removeFromSuperview()
    }
    

}
