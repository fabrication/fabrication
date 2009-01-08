package org.puremvc.as3.multicore.utilities.fabrication.patterns.interceptor {
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.utilities.fabrication.events.NotificationProcessorEvent;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	
	import com.anywebcam.mock.Mock;
	
	import flexunit.framework.SimpleTestCase;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class NotificationProcessorTest extends SimpleTestCase {

		public var processor:NotificationProcessor;
		public var note:Notification;

		public function NotificationProcessorTest(method:String) {
			super(method);
		}

		override public function setUp():void {
			note = new Notification(methodName + "note");
			processor = new NotificationProcessor(note);
		}

		override public function tearDown():void {
			processor.dispose();
			
			note = null;
			processor = null;
		}

		public function testNotificationProcessorHasValidType():void {
			assertType(NotificationProcessor, processor);
			assertType(IDisposable, processor);
		}

		public function testNotificationProcessorConstructorSavesNotification():void {
			assertEquals(note, processor.getNotification());
		}

		public function testNotificationProcessorCanStoreInterceptors():void {
			var interceptor:InterceptorMock = new InterceptorMock();
			interceptor.mock.property("processor").withArgs(processor).once;
			interceptor.mock.method("intercept").withNoArgs.once;
			
			processor.addInterceptor(interceptor);
			processor.run();
			
			verifyMock(interceptor.mock);
		}

		public function testNotificatonProcessorCanRemoveInterceptors():void {
			var interceptor:InterceptorMock = new InterceptorMock();
			interceptor.mock.property("intercept").withNoArgs.never;
			interceptor.mock.method("dispose").withNoArgs.once;
			
			processor.addInterceptor(interceptor);
			processor.removeInterceptor(interceptor);
			processor.run();
			
			verifyMock(interceptor.mock);
		}

		public function testNotificationProcessorRunsOnAllRegisteredInterceptors():void {
			var sampleSize:int = 25;
			var interceptor:InterceptorMock;
			var interceptors:Array = new Array();
			var i:int;
			
			for (i = 0;i < sampleSize; i++) {
				interceptor = new InterceptorMock();
				interceptor.mock.property("notification").withArgs(note);
				interceptor.mock.method("intercept").withNoArgs.once;
			
				interceptors.push(interceptor);	
				processor.addInterceptor(interceptor);
			}
			
			processor.run();
			
			for (i = 0;i < sampleSize; i++) {
				interceptor = interceptors[i];
				verifyMock(interceptor.mock);
			}
		}

		public function testNotificationProcessorSendsProceedEventOnProceed():void {
			var verifyProceedEvent:Function = function(event:NotificationProcessorEvent):void {
				assertNotNull(event.notification);
				assertTrue(event.notification == note);
			};
			
			processor.addEventListener(NotificationProcessorEvent.PROCEED, addAsync(verifyProceedEvent, 100));
			processor.proceed(note);
		}

		public function testNotificationProcessorDoesNotSendProceedEventOnFinish():void {
			var verifyProceedEvent:Function = function(event:NotificationProcessorEvent):void {
				
			};
			
			var noProceed:Boolean = true;
			var verifyNoProceedEvent:Function = function(event:NotificationProcessorEvent):void {
				noProceed = false;
			};
			
			processor.addEventListener(NotificationProcessorEvent.PROCEED, addAsync(verifyProceedEvent, 100));
			processor.proceed(note);
			
			processor.addEventListener(NotificationProcessorEvent.PROCEED, verifyNoProceedEvent);
			processor.proceed(note);
			
			assertTrue(noProceed);
		}
		
		public function testNotificationProcessorSendsFinishEventOnProceed():void {
			var verifyFinishEvent:Function = function(event:NotificationProcessorEvent):void {
				assertTrue(NotificationProcessorEvent.FINISH == event.type);
			};
			
			processor.addEventListener(NotificationProcessorEvent.FINISH, addAsync(verifyFinishEvent, 100));
			processor.proceed(note);
		}
		
		public function testNotificationProcessorSendsAbortEventOnAbort():void {
			var verifyAbortEvent:Function = function(event:NotificationProcessorEvent):void {
				assertTrue(NotificationProcessorEvent.ABORT == event.type);
			};
			
			processor.addEventListener(NotificationProcessorEvent.ABORT, addAsync(verifyAbortEvent, 100));
			processor.abort();
		}
		
		public function testNotificationProcessorSendsFinishAfterAllInterceptorsHaveSkipped():void {
			var sampleSize:int = 20;
			var i:int;
			var count:int = 0;
			var verifyFinishEvent:Function = function(event:NotificationProcessorEvent):void {
				assertEquals(NotificationProcessorEvent.FINISH, event.type);
				count++;
			};
			
			processor.addEventListener(NotificationProcessorEvent.FINISH, verifyFinishEvent);
			
			for (i = 0; i < sampleSize; i++) {
				processor.addInterceptor(new InterceptorMock());				
			}
			
			for (i = 0; i < sampleSize - 1; i++) {
				processor.skip();
			}
			
			assertEquals(0, count);
			
			processor.skip();
			assertEquals(1, count);
		}
		
		public function testNotificationProcessorResetsOnDisposal():void {
			var processor:NotificationProcessor = new NotificationProcessor(note);			
			var sampleSize:int = 20;
			var interceptors:Array = new Array();
			var interceptor:InterceptorMock;
			var i:int;
			
			for (i = 0; i < sampleSize; i++) {
				interceptor = new InterceptorMock();
				interceptor.mock.method("dispose").withNoArgs.once;
				
				interceptors.push(interceptor);
				processor.addInterceptor(interceptor);
			}
			
			processor.dispose();
			
			assertNull(processor.getNotification());
			
			for (i = 0; i < sampleSize; i++) {
				interceptor = interceptors[i];
				verifyMock(interceptor.mock);
			}
		}
		
	}
}
