//
//  OnboardingViewController.swift
//  BudgetProject
//
//  Created by User on 19.05.24.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    // MARK: - properties
    private var pages = [OnboardingViewPartController]()
    private var cuurrentPageIndex = 0
    //MARK: - views
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private let bottomButton = UIButton()
    
    private let pageControl = UIPageControl()
    var viewOutput: OnboardingViewOutput!
    
    init(pages: [OnboardingViewPartController] = [OnboardingViewPartController](), viewOutput: OnboardingViewOutput!) {
        self.pages = pages
        self.viewOutput = viewOutput
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPageViewController()
        setupPageControl()
        setupButton()
        
    }
    
}


//MARK: - action

private extension OnboardingViewController{
    
    @objc func buttonPressed(){
        switch pageControl.currentPage{
            
        case 0:
            pageControl.currentPage = 1
            pageViewController.setViewControllers([pages[1]], direction: .forward, animated: true, completion: nil)
            bottomButton.setTitle(pages[1].buttonText, for: .normal )
        case 1:
            pageControl.currentPage = 2
            pageViewController.setViewControllers([pages[2]], direction: .forward, animated: true, completion: nil)
            bottomButton.setTitle(pages[2].buttonText, for: .normal )
        case 2:
           
            viewOutput.onboardingFinish()
            
        default:
            break
        }
    }
}



//MARK: - Layout
private extension OnboardingViewController{
    func setupPageViewController(){
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        pageViewController.setViewControllers([pages.first!], direction: .forward, animated: true)
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
    }
    func setupPageControl(){
        
        pageControl.numberOfPages = pages.count
        
        pageControl.currentPage = 0
        
        let page = pages[0]
        let title =  page.buttonText
        bottomButton.setTitle(title, for: .normal)
        
        
        pageControl.isUserInteractionEnabled = false
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -45)
        ])
    }
    func setupButton(){
        view.addSubview(bottomButton)
        bottomButton.translatesAutoresizingMaskIntoConstraints = false
        bottomButton.backgroundColor = AppColors.black
        bottomButton.titleLabel?.font = .Roboto.bold.size(of: 18)
        bottomButton.setTitleColor(AppColors.accentOrange, for: .normal)
        bottomButton.layer.cornerRadius = 12
        bottomButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        NSLayoutConstraint.activate([
            bottomButton.bottomAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: -99),
            bottomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            bottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            bottomButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

//MARK: -UIPAgeViewControllerDataSource delegate
extension OnboardingViewController: UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController as! OnboardingViewPartController), currentIndex > 0 else { return nil }
        return pages[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController as! OnboardingViewPartController), currentIndex < pages.count - 1 else { return nil }
        return pages[currentIndex + 1]
    }
    
    
}

extension OnboardingViewController: UIPageViewControllerDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let index = pages.firstIndex(of: pendingViewControllers.first! as! OnboardingViewPartController){
           
            
            cuurrentPageIndex = index
            
            
        }
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed{
            pageControl.currentPage = cuurrentPageIndex
            
            let page = pages[cuurrentPageIndex]
            let title =  page.buttonText
            bottomButton.setTitle(title, for: .normal)
           
        }
    }
}
