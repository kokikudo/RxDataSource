//
//  ViewController.swift
//  RxDataSource
//
//  Created by kudo koki on 2023/03/11.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var viewModel: PageItemViewModel!
    private let disposeBag = DisposeBag()
    private var pageVC = MyPageViewController()
    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<PageItemSectionModel>(configureCell: configureCell)
    
    private lazy var configureCell: RxCollectionViewSectionedReloadDataSource<PageItemSectionModel>.ConfigureCell = { [weak self] (_, tableView, indexPath, item) in
        guard let safeSeft = self else { return UICollectionViewCell() }
        switch item {
        case .item(let item):
            return safeSeft.articleCell(indexPath: indexPath, item: item)
        }
    }
    
    private lazy var pageItems: [PageItem] = {
        let items = PageTypeEnum.allCases.map { type in
            return PageItem.item(item: Item(no: type.rawValue, image: type.icon, isOn: false))
        }
        return items
    }() {
        didSet {
            if pageItems.count == oldValue.count { return }
            viewModel.updateItems(pageItems)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPageVC()
        setupCollectionView()
        setupViewModel()
        bind()
    }
    
    private func bind() {
        disposeBag.insert(
            pageVC.scrollEvent.bind(onNext: scrollCompletion)
        )
    }
    
    private func scrollCompletion(row: Int) {
        let indexPath: IndexPath = [0, row]
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    private func setPageVC() {
        
        addChild(pageVC)
        view.addSubview(pageVC.view)
        view.constraintToEdge(pageVC.view)
        pageVC.didMove(toParent: self)
        view.bringSubviewToFront(collectionView)
        view.bringSubviewToFront(button)
    }
    
    @IBOutlet weak var button: UIButton!
    
    @IBAction func actionAddItem(_ sender: Any) {
        let newItem = PageItem.item(item: Item(no: 8, image: UIImage.add, isOn: false))
        pageItems.append(newItem)
    }
}

extension ViewController {
    
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: "PageIconCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: PageIconCollectionViewCell.identifier)
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        collectionView.rx.itemSelected
            .map { [weak self] indexPath -> (PageItem?, IndexPath) in
                return (self?.dataSource[indexPath], indexPath)
            }
            .subscribe(onNext: { [weak self] item, indexPath in
                // セルをタップしたとき、ここが呼ばれる
                guard let item = item else { return }
                switch item {
                case .item(let item):
                    self?.pageVC.moveVC(row: item.no)
                    self?.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupViewModel() {
        viewModel = PageItemViewModel()
        // ここでdataSourceをdrive(bind)しておくことで、データの更新＆Viewの更新をきにしなくてもよくなる
        viewModel.items
            .asDriver()
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        viewModel.updateItems(pageItems)
    }
    
    private func articleCell(indexPath: IndexPath, item: Item) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageIconCollectionViewCell.identifier, for: indexPath) as? PageIconCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.update(iconImage: item.image)
        return cell
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
}
