/**
 * Copyright (C) 2009 Darshan Sawardekar.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.puremvc.as3.multicore.utilities.fabrication.patterns.interceptor {
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IInterceptor;
	
	import flexunit.framework.SimpleTestCase;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class AbstractInterceptorTest extends SimpleTestCase {
		
		public var interceptor:AbstractInterceptor;
		
		public function AbstractInterceptorTest(method:String) {
			super(method);
		}
		
		override public function setUp():void {
			interceptor = new AbstractInterceptor();
		}
		
		override public function tearDown():void {
			interceptor = null;
		}
		
		public function testAbstractInterceptorHasValidType():void {
			assertType(AbstractInterceptor, interceptor);
			assertType(IInterceptor, interceptor);
			assertType(IDisposable, interceptor);
		}
		
		public function testAbstractInterceptorProceedsWithSpecifiedNotification():void {
			var note:Notification = new Notification(methodName);
			var processor:NotificationProcessorMock = new NotificationProcessorMock(note);
			
			processor.mock.method("proceed").withArgs(note).once;
			interceptor.processor = processor;
			interceptor.proceed(note);
			
			verifyMock(processor.mock);
		}
		
		public function testAbstractInterceptorProceedsWithCurrentNotificationWhenNotSpecified():void {
			var note:Notification = new Notification(methodName);
			var processor:NotificationProcessorMock = new NotificationProcessorMock(note);
			
			processor.mock.method("proceed").withArgs(note).once;
			interceptor.processor = processor;
			interceptor.notification = note;
			interceptor.proceed();
			
			verifyMock(processor.mock);
		}
		
		public function testAbstractInterceptorAbortsNotificationOnProcessor():void {
			var note:Notification = new Notification(methodName);
			var processor:NotificationProcessorMock = new NotificationProcessorMock(note);
			
			processor.mock.method("abort").withNoArgs.once;
			interceptor.processor = processor;
			interceptor.abort();
		}
		
		public function testAbstractInterceptorSkipsNotificationOnProcessor():void {
			var note:Notification = new Notification(methodName);
			var processor:NotificationProcessorMock = new NotificationProcessorMock(note);
			
			processor.mock.method("skip").withNoArgs.once;
			interceptor.processor = processor;
			interceptor.skip();
		}
		
		public function testAbstractInterceptorSavesNotification():void {
			assertProperty(interceptor, "notification", INotification, null, new Notification(methodName));
		}
		
		public function testAbstractInterceptorSavesProcessor():void {
			assertProperty(interceptor, "processor", NotificationProcessor, null, new NotificationProcessor(new Notification(methodName)));
		}
		
		public function testAbstractInterceptorSavesParameters():void {
			assertProperty(interceptor, "parameters", Object, null, new Object());
		}
		
	}
}
