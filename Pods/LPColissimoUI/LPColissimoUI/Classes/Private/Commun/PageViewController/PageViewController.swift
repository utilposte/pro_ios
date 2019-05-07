//
//  PageView.swift
//  ActiveLabel
//
//  Created by PENA SANCHEZ Edwin Jose on 08/04/2019.
//
import UIKit

class PageViewController: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - Outlets
    
    @IBOutlet var dotsView: UIView!
    @IBOutlet var pageCollectionView: UICollectionView!
    
    var needsUpdateIndicators = false
    var needsCreateIndicators = false
    var indicatorLayers = [CAShapeLayer]()
    var timer: Timer?
    var automaticSlidingInterval: CGFloat = 3.0
    var dotsInteritemSpacing: CGFloat = 10.0
    var dotsDiameter: CGFloat = 8.0
    var items: [UIImage] = []
    var isInfinite: Bool = true
    
    // MARK: - Dynamic Var
    
    var numberOfSections: Int = 0
    open var sizeWidth: CGFloat {
        return self.frame.width
    }
    
    var numberOfItems: Int {
        if self.items.count == 1 {
            self.removesInfiniteLoopForSingleItem = true
        }
        return self.items.count
    }
    
    var actualItemSize: CGSize {
        return CGSize(width: sizeWidth, height: self.frame.height)
    }
    
    open var currentPage: Int = 0 {
        didSet {
            self.setNeedsUpdateIndicators()
        }
    }
    
    var removesInfiniteLoopForSingleItem: Bool = false {
        didSet {
            self.pageCollectionView.reloadData()
        }
    }
    
    /// The percentage of x position at which the origin of the content view is offset from the origin of the pagerView view.
    open var scrollOffset: CGFloat {
        let contentOffset = max(pageCollectionView.contentOffset.x, pageCollectionView.contentOffset.y)
        let scrollOffset = Double(contentOffset / self.frame.width)
        return fmod(CGFloat(scrollOffset), CGFloat(Double(numberOfItems)))
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupViews()
    }
    
    deinit {
        cancelTimer()
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        let spacing: CGFloat = dotsInteritemSpacing
        var xPoint: CGFloat = {
            0
        }()
        self.indicatorLayers.forEach { value in
            let size = CGSize(width: dotsDiameter, height: dotsDiameter)
            let origin = CGPoint(x: xPoint - (size.width - dotsDiameter) * 0.5, y: self.dotsView.bounds.midY - size.height * 0.5)
            value.frame = CGRect(origin: origin, size: size)
            xPoint += (spacing + dotsDiameter)
        }
    }
    
    // MARK: - Accessible methods
    
    func configureCell(items: [UIImage]) {
        self.items = items
        self.pageCollectionView.reloadData()
        self.pageCollectionView.isPagingEnabled = true
        self.dotsView.isHidden = false
        self.dotsView.frame.size.width = CGFloat(Double(self.numberOfItems) * 11.0)
        self.setNeedsCreateIndicators()
        self.startTimer()
    }
    
    func setupViews() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.pageCollectionView.collectionViewLayout = layout
        self.pageCollectionView.isPagingEnabled = true
        self.pageCollectionView.backgroundColor = UIColor.clear
        self.pageCollectionView.showsHorizontalScrollIndicator = false
        self.pageCollectionView.showsVerticalScrollIndicator = false
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.actualItemSize
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard self.numberOfItems > 0 else { return 0 }
        self.numberOfSections = self.isInfinite &&
            (self.numberOfItems > 1 || !self.removesInfiniteLoopForSingleItem) ? Int(Int16.max) / self.numberOfItems : 1
        self.adjustCollectionViewBounds()
        return self.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pageCellViewModel = self.items[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pageCollectionCellID", for: indexPath) as! UICollectionViewCell
        let imageView: UIImageView = {
            let iv = UIImageView()
            iv.image = pageCellViewModel
            iv.contentMode = .scaleToFill
            return iv
        }()
        cell.backgroundView = imageView
        return cell
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.numberOfItems > 0 {
            let currentPage = lround(Double(self.scrollOffset)) % self.numberOfItems
            if currentPage != self.currentPage {
                self.currentPage = currentPage
            }
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        cancelTimer()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        startTimer()
    }
    
    // MARK: - Private methods
    
    private func adjustCollectionViewBounds() {
        guard let collectionView = self.pageCollectionView else {
            return
        }
        let currentIndex = max(0, min(currentPage, numberOfItems - 1))
        let newIndexPath = IndexPath(item: currentIndex, section: self.isInfinite ? self.numberOfSections / 2 : 0)
        let contentOffset = self.contentOffset(for: newIndexPath)
        let newBounds = CGRect(origin: contentOffset, size: collectionView.frame.size)
        collectionView.bounds = newBounds
        self.currentPage = currentIndex
    }
}

/// Manager slide automatic
extension PageViewController {
    func cancelTimer() {
        guard self.timer != nil else {
            return
        }
        self.timer!.invalidate()
        self.timer = nil
    }
    
    func startTimer() {
        if self.numberOfItems < 1 {
            return
        }
        guard self.automaticSlidingInterval > 0, self.timer == nil else {
            return
        }
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.automaticSlidingInterval),
                                          target: self,
                                          selector: #selector(self.flipNext(sender:)),
                                          userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer!, forMode: .commonModes)
    }
    
    @objc private func flipNext(sender: Timer?) {
        guard let _ = self.superview, let _ = self.window, self.numberOfItems > 0 else {
            return
        }
        let contentOffset: CGPoint = {
            let indexPath = self.centermostIndexPath()
            let section = self.numberOfSections > 1 ? (indexPath.section+(indexPath.item+1)/self.numberOfItems) : 0
            let item = (indexPath.item + 1) % numberOfItems
            return self.contentOffset(for: IndexPath(item: item, section: section))
        }()
        self.pageCollectionView.setContentOffset(contentOffset, animated: true)
    }
    
    private func centermostIndexPath() -> IndexPath {
        guard self.numberOfItems > 0, self.pageCollectionView.contentSize != .zero else {
            return IndexPath(item: 0, section: 0)
        }
        let sortedIndexPaths = pageCollectionView.indexPathsForVisibleItems.sorted { (leftIndex, rightIndex) -> Bool in
            let leftFrame = self.frame(for: leftIndex)
            let rightFrame = self.frame(for: rightIndex)
            var leftCenter: CGFloat, rightCenter: CGFloat, ruler: CGFloat
            leftCenter = leftFrame.midX
            rightCenter = rightFrame.midX
            ruler = pageCollectionView.bounds.midX
            return abs(ruler - leftCenter) < abs(ruler - rightCenter)
        }
        let indexPath = sortedIndexPaths.first
        if let indexPath = indexPath {
            return indexPath
        }
        return IndexPath(item: 0, section: 0)
    }
    
    private func contentOffset(for indexPath: IndexPath) -> CGPoint {
        let origin = self.frame(for: indexPath).origin
        let contentOffsetX: CGFloat = {
            let contentOffsetX = origin.x - (pageCollectionView.frame.width * 0.5 - self.actualItemSize.width * 0.5)
            return contentOffsetX
        }()
        let contentOffsetY: CGFloat = {
            0
        }()
        let contentOffset = CGPoint(x: contentOffsetX, y: contentOffsetY)
        return contentOffset
    }
    
    private func frame(for indexPath: IndexPath) -> CGRect {
        let numberOfItems = self.numberOfItems * indexPath.section + indexPath.item
        let originX: CGFloat = {
            CGFloat(numberOfItems) * self.actualItemSize.width
        }()
        let originY: CGFloat = {
            (pageCollectionView.frame.height - self.actualItemSize.height) * 0.5
        }()
        let origin = CGPoint(x: originX, y: originY)
        let frame = CGRect(origin: origin, size: self.actualItemSize)
        return frame
    }
}

/// Manager create dots
extension PageViewController {
    private func setNeedsUpdateIndicators() {
        self.needsUpdateIndicators = true
        self.setNeedsLayout()
        DispatchQueue.main.async {
            self.updateIndicatorsIfNecessary()
        }
    }
    
    private func updateIndicatorsIfNecessary() {
        guard self.needsUpdateIndicators else {
            return
        }
        guard !self.indicatorLayers.isEmpty else {
            return
        }
        self.needsUpdateIndicators = false
        self.dotsView.isHidden = self.items.count <= 1
        if !self.dotsView.isHidden {
            self.indicatorLayers.forEach { layer in
                layer.isHidden = false
                self.updateIndicatorAttributes(for: layer)
            }
        }
    }
    
    private func updateIndicatorAttributes(for layer: CAShapeLayer) {
        let index = self.indicatorLayers.index(of: layer)
        let state: UIControl.State = index == self.currentPage ? .selected : .normal
        layer.contents = nil
        layer.fillColor = (state == .selected ? UIColor.white : UIColor.lightGray).cgColor
        layer.strokeColor = nil
        layer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: dotsDiameter, height: dotsDiameter)).cgPath
        layer.opacity = Float(1.0)
    }
    
    private func setNeedsCreateIndicators() {
        self.needsCreateIndicators = true
        DispatchQueue.main.async {
            self.createIndicatorsIfNecessary()
        }
    }
    
    private func createIndicatorsIfNecessary() {
        guard self.needsCreateIndicators else {
            return
        }
        self.needsCreateIndicators = false
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        if self.currentPage >= self.numberOfItems {
            self.currentPage = self.numberOfItems - 1
        }
        self.indicatorLayers.forEach { layer in
            layer.removeFromSuperlayer()
        }
        self.indicatorLayers.removeAll()
        for _ in 0..<self.numberOfItems {
            let layer = CAShapeLayer()
            layer.actions = ["bounds": NSNull()]
            self.dotsView.layer.addSublayer(layer)
            self.indicatorLayers.append(layer)
        }
        self.setNeedsUpdateIndicators()
        self.updateIndicatorsIfNecessary()
        CATransaction.commit()
    }
}
