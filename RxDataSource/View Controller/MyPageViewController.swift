import UIKit
import RxSwift

class MyPageViewController: UIPageViewController {
    
    var scrollEvent: Observable<Int> { return scrollSubject }
    private let scrollSubject = PublishSubject<Int>()
    private var pages = [UIViewController]()
    private var currentPageIndex: Int {
        guard let vc = viewControllers?.first else { return 0 }
        return pages.firstIndex(of: vc) ?? 0
    }
    
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .pageCurl, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        addPage()
        setViewControllers([pages[0]], direction: .forward, animated: false)
    }
    
    private func addPage() {
        for i in 0..<PageTypeEnum.allCases.count {
            let vc = ColorBGViewController()
            vc.theLabel.text = "Page \(i)"
            vc.view.backgroundColor = PageTypeEnum(rawValue: i)?.color
            pages.append(vc)
        }
    }
    
    func moveVC(row: Int) {
        guard PageTypeEnum.allCases.indices.contains(row) else { return }
        let direction: UIPageViewController.NavigationDirection = row > currentPageIndex ? .forward : .reverse
        setViewControllers([pages[row]], direction: direction, animated: true)
    }
}

extension MyPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else { return pages.last }
        
        guard pages.count > previousIndex else { return nil }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else { return pages.first }
        
        guard pages.count > nextIndex else { return nil }
        
        return pages[nextIndex]
    }
    
}

extension MyPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed { scrollSubject.onNext(currentPageIndex)}
    }
}
