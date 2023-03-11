import RxCocoa
import RxSwift
import RxDataSources

struct Item {
    let no: Int
    let image: UIImage
    let isOn: Bool
}

typealias PageItemSectionModel = SectionModel<PageSection, PageItem>
enum PageSection {
    case icon
}
enum PageItem {
    case item(item: Item)
}
class PageItemViewModel {
    let items = BehaviorRelay<[PageItemSectionModel]>(value: [])
    
    func updateItems(_ items: [PageItem]) {
        var sections: [PageItemSectionModel] = []
        let articleSection = PageItemSectionModel(model: .icon, items: items)
        sections.append(articleSection)

        self.items.accept(sections)
    }
}

struct Article {
    let title: String
    let updatedAt: Date
    let color: UIColor
}

typealias TimelineSectionModel = SectionModel<TimelineSection, TimelineItem>

enum TimelineSection {
    case news
}

enum TimelineItem {
    case article(article: Article)
    // case ad(ad: Advertise) ニュース記事の他に広告を挿入したい場合はここに追加する
}

class TimelineViewModel {
    let items = BehaviorRelay<[TimelineSectionModel]>(value: [])

    func updateItems() {
        var sections: [TimelineSectionModel] = []

        let item1 = TimelineItem.article(article: Article(title: "コミックマーケットでスリをした２６歳男性逮捕", updatedAt: Date(), color: .red))
        let item2 = TimelineItem.article(article: Article(title: "２７日明け方頃から関東全域に大雨の予想", updatedAt: Date(), color: .brown))
        let item3 = TimelineItem.article(article: Article(title: "夫が知らない　妻の帰省ストレス", updatedAt: Date(), color: .blue))
        let articleSection = TimelineSectionModel(model: .news, items: [item1, item2, item3])
        sections.append(articleSection)

        items.accept(sections)
    }
}
