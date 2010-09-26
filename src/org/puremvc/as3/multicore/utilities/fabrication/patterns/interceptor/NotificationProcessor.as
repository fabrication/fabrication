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
	import org.puremvc.as3.multicore.utilities.fabrication.events.NotificationProcessorEvent;	
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;	
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IInterceptor;	
	
	import flash.events.EventDispatcher;
	
	import org.puremvc.as3.multicore.interfaces.INotification;		

	/**
	 * The NotificationProcessor aggregates interceptors for a notification
	 * and sends proceeds, abort or skip notification when interceptors added to it
	 * perform the corresponding interception.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class NotificationProcessor extends EventDispatcher implements IDisposable {

		/**
		 * Stores the interceptor instances registered with this processor.
		 */
		protected var interceptors:Array;
		
		/**
		 * Stores the notification object that is to be processed.
		 */
		protected var notification:INotification;
		
		/**
		 * Flag is used to mark this NotificationProcessor as complete.
		 * This blocks all future interceptions.
		 */
		protected var finished:Boolean = false;
		
		/**
		 * The number of interceptors that have skipped the current notification.
		 */
		protected var skipCount:int;
		
		/**
		 * Creates a new NotificationProcessor object.
		 * 
		 * @param notification The notification object to be processed.
		 */
		public function NotificationProcessor(notification:INotification) {
			this.notification = notification;
			
			interceptors = new Array();
			skipCount = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function dispose():void {
			var n:int = interceptors.length;
			var interceptor:IInterceptor;
			for (var i:int = 0; i < n; i++) {
				interceptor = interceptors[i];
				interceptor.dispose();
				
				interceptors[i] = null;
			}
			
			interceptors = null;
			notification = null;
		}
		
		/**
		 * Returns the original notification object to be processed.
		 */
		public function getNotification():INotification {
			return notification;
		}
		
		/**
		 * Adds a interceptor to the list of interceptors for the current notification.
		 * 
		 * @param interceptor The interceptor object to register.
		 */
		public function addInterceptor(interceptor:IInterceptor):void {
			interceptor.processor = this;			
			interceptors.push(interceptor);
		}
		
		/**
		 * Removes the specified interceptor from the list of interceptors.
		 * 
		 * @param interceptor The interceptor object to remove.
		 */
		public function removeInterceptor(interceptor:IInterceptor):void {
			var index:int = interceptors.indexOf(interceptor);
			if (index >= 0) {
				interceptors.splice(index, 1);
				interceptor.dispose();
			}
		}
		
		/**
		 * Runs all interceptors registered with this NotificationProcessor.
		 */
		public function run():void {
			var n:int = interceptors.length;
			var interceptor:IInterceptor;
			for (var i:int = 0; i < n; i++) {
				interceptor = interceptors[i];
				
				interceptor.notification = notification;
				interceptor.intercept();
			}
		}
		
		/**
		 * Sends a proceed event so that the notification can be send to the rest of
		 * the PureMVC actors. Flags this instance as complete to ignore other interceptors.
		 * Also sends a finish event to indicate that the processor can be disposed.
		 * 
		 * @param note The notification to proceed with. If null the current notification object is used.
		 */
		public function proceed(note:INotification = null):void {
			if (!finished) {
				dispatchEvent(new NotificationProcessorEvent(NotificationProcessorEvent.PROCEED, note));
				finish();
			}
		}

		/**
		 * Sends an abort event. Flags this instance as complete to ignore other interceptors.
		 * Also sends a finish event to indicate that the processor can be disposed.
		 */
		public function abort():void {
			if (!finished) {
				dispatchEvent(new NotificationProcessorEvent(NotificationProcessorEvent.ABORT));
				finish();
			}
		}
		
		/**
		 * If all interceptors have been skipped then sends a finish event to indicate
		 * that the processor can be disposed.
		 */
		public function skip():void {
			if (!finished && ++skipCount == interceptors.length) {
				finish();
			}
		}
		
		/**
		 * Flags the notification as finished and sends a finish event.
		 */
		public function finish():void {
			finished = true;
			dispatchEvent(new NotificationProcessorEvent(NotificationProcessorEvent.FINISH));
		}
		
	}
}
