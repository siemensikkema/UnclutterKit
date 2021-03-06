import Foundation

public class SimpleDataSource<Model, Item, S: SectionProtocol> where S.Element == Model {

	public var sections: [S]

	public init(sections: [S], transform: @escaping (SimpleDataSource, Model) -> Item) {
		self.sections = sections
		self.transform = transform
	}

	fileprivate let transform: (SimpleDataSource, Model) -> Item
}

extension SimpleDataSource: DataSourceProtocol {

	public func item(at indexPath: IndexPath) -> Item {
		return transform(self, sections[indexPath.section].items[indexPath.row])
	}

	public func numberOfItems(inSection section: Int) -> Int {
		return sections[section].items.count
	}

	public func numberOfSections() -> Int {
		return sections.count
	}

	public func titleForHeader(inSection section: Int) -> String? {
		return sections[section].title
	}
}
