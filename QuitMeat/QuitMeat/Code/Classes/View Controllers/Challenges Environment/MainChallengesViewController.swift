//
//  MainChallengesViewController.swift
//  QuitMeat
//
//  Controller of the Main Challenges View (view not visible for user).
//
//  Created by Melle Meewis on 23/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import UIKit

class MainChallengesViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // Declare variables
    var pageControl = UIPageControl()
    lazy var viewControllerList:[UIViewController] = {
        let sb = UIStoryboard(name: "Main", bundle: nil)
    
        let challengesUserVC = sb.instantiateViewController(withIdentifier: "ChallengesUserViewController")
        let chooseChallengeVC = sb.instantiateViewController(withIdentifier: "ChooseChallengeViewController")
    
        return [challengesUserVC, chooseChallengeVC]
    }()
    
    /// Return viewcontroller before
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.index(of: viewController) else {return nil}
        let previousIndex = vcIndex - 1
        guard previousIndex >= 0 else {return nil}
        guard viewControllerList.count > previousIndex else {return nil}
        return viewControllerList[previousIndex]
    }
    
    /// Return viewcontroller after
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.index(of: viewController) else {return nil}
        let nextIndex = vcIndex + 1
        guard viewControllerList.count != nextIndex  else {return nil}
        guard viewControllerList.count > nextIndex else {return nil}
        return viewControllerList[nextIndex]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // additional setup
        self.dataSource = self
        self.delegate = self
        if let challengesUserViewController = viewControllerList.first {
            self.setViewControllers([challengesUserViewController], direction: .forward, animated: true, completion: nil)
        }
        configurePageControl()
    }
    
    // Configure the page indicator
    func configurePageControl() {
        pageControl = UIPageControl(frame: CGRect(x: UIScreen.main.bounds.width / 2,y: UIScreen.main.bounds.maxY - 20,width: 0,height: 0))
        self.pageControl.numberOfPages = viewControllerList.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
    }
    
    // set page indicator on current page
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = viewControllerList.index(of: pageContentViewController)!
    }
    
}
