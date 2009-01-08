package org.puremvc.as3.multicore.utilities.fabrication.patterns.interceptor {
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IInterceptor;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mock.SimpleFabricationCommandMock;		

	/**
	 * @author Darshan Sawardekar
	 */
	public class InterceptorMock extends SimpleFabricationCommandMock implements IInterceptor{

		private var _parameters:Object;

		public function InterceptorMock() {
			super();
		}

		public function intercept():void {
			if (parameters != null && parameters.method != null) {
				parameters.method(this);
			} else {
				mock.intercept();
			}
		}

		public function proceed(note:INotification = null):void {
			mock.proceed(note);
		}

		public function abort():void {
			mock.abort();
		}

		public function skip():void {
			mock.skip();
		}

		public function get notification():INotification {
			return mock.notification;
		}

		public function set notification(notification:INotification):void {
			mock.notification = notification;
		}

		public function get processor():NotificationProcessor {
			return mock.processor;
		}

		public function set processor(processor:NotificationProcessor):void {
			mock.processor = processor;
		}

		public function get parameters():Object {
			mock.parameters;
			return _parameters;
		}

		public function set parameters(parameters:Object):void {
			_parameters = parameters;
			mock.parameters = parameters;
		}
	}
}
