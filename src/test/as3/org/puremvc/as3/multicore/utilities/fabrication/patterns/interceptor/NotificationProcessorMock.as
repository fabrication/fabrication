package org.puremvc.as3.multicore.utilities.fabrication.patterns.interceptor {
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IInterceptor;
	
	import com.anywebcam.mock.Mock;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class NotificationProcessorMock extends NotificationProcessor {
		
		private var _mock:Mock;
		
		public function NotificationProcessorMock(notification:INotification) {
			super(notification);
		}
		
		public function get mock():Mock {
			if (_mock == null) {
				_mock = new Mock(this, true);
			};
			
			return _mock;
		}
		
		override public function dispose():void {
			mock.dispose();
		}
		
		override public function getNotification():INotification {
			return mock.getNotification();
		}
		
		override public function addInterceptor(interceptor:IInterceptor):void {
			mock.addInterceptor(interceptor);
		}
		
		override public function removeInterceptor(interceptor:IInterceptor):void {
			mock.removeInterceptor(interceptor);
		}
		
		override public function run():void {
			mock.run();
		}
		
		override public function proceed(note:INotification = null):void {
			mock.proceed(note);
		}
		
		override public function abort():void {
			mock.abort();
		}
		
		override public function skip():void {
			mock.skip();
		}
		
		override public function finish():void {
			mock.finish();
		}
		
	}
}
