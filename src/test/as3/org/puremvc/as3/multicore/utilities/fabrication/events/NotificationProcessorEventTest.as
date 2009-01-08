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

package org.puremvc.as3.multicore.utilities.fabrication.events {
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	
	import flexunit.framework.SimpleTestCase;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class NotificationProcessorEventTest extends SimpleTestCase {

		public var event:NotificationProcessorEvent;

		public function NotificationProcessorEventTest(method:String) {
			super(method);
		}

		override public function setUp():void {
			event = new NotificationProcessorEvent(NotificationProcessorEvent.PROCEED);
		}

		override public function tearDown():void {
			event.dispose();
			event = null;
		}

		public function testNotificationProcessorEventHasValidType():void {
			assertType(NotificationProcessorEvent, event);
			assertType(IDisposable, event);
		}
		
		public function testNotificationProcessorEventHasProceedType():void {
			assertNotNull(NotificationProcessorEvent.PROCEED);
			assertType(String, NotificationProcessorEvent.PROCEED);
		}
		
		public function testNotificationProcessorEventHasAbortType():void {
			assertNotNull(NotificationProcessorEvent.ABORT);
			assertType(String, NotificationProcessorEvent.ABORT);
		}
		
		public function testNotificationProcessorEventHasFinishType():void {
			assertNotNull(NotificationProcessorEvent.FINISH);
			assertType(String, NotificationProcessorEvent.FINISH);
		}
		
		public function testNotificationProcessorEventConstructorStoresTypeAndNotification():void {
			var notification:Notification = new Notification(methodName);
			event = new NotificationProcessorEvent(NotificationProcessorEvent.PROCEED, notification);
			
			assertEquals(NotificationProcessorEvent.PROCEED, event.type);
			assertEquals(notification, event.notification);
		}
		
		public function testNotificationProcessorEventResetsOnDisposal():void {
			var event:NotificationProcessorEvent = new NotificationProcessorEvent(NotificationProcessorEvent.PROCEED, new Notification(methodName));
			event.dispose();
			
			assertNull(event.notification);
		}
	}
}
