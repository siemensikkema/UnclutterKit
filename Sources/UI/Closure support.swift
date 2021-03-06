import UIKit

public protocol ClosureSupport {}

extension UIBarButtonItem: ClosureSupport {}
extension ClosureSupport where Self: UIBarButtonItem {
	public func setAction(callback: @escaping (Self) -> Void) {
		let _target = Target(callback: callback)
		objc_setAssociatedObject(self, &associationKey, _target, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		target = _target
		action = #selector(Target.action)
	}
}

extension UIControl: ClosureSupport {}
extension ClosureSupport where Self: UIControl {

	public func setAction(for controlEvents: UIControlEvents = .touchUpInside,
	                      callback: @escaping (Self) -> Void) {
		let target = Target(callback: callback)
		objc_setAssociatedObject(self, &associationKey, target, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		addTarget(target, action: #selector(Target.action), for: controlEvents)
	}
}

private final class Target<T: NSObject> {
	typealias Callback = (T) -> Void
	let callback: Callback

	init(callback: @escaping Callback) {
		self.callback = callback
	}

	func bridgingAction(control: T) {
		callback(control)
	}

	@objc func action(object: NSObject) {
		bridgingAction(control: object as! T) // swiftlint:disable:this force_cast
	}
}

private var associationKey: UInt8 = 0
