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
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IInterceptor;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;	
	/**
	 * The AbstractInterceptor is the base class for creating interceptors. It provides
	 * most of the implementation of the IInterceptor interface. Subclasses only need to
	 * implement the intercept method.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class AbstractInterceptor extends SimpleFabricationCommand implements IInterceptor {

		/**
		 * The notification object assigned to this interceptor. This object is assigned
		 * before the intercept method is called.
		 */
		protected var _notification:INotification;

		/**
		 * The notification processor object assigned to this interceptor.
		 */
		protected var _processor:NotificationProcessor;
		
		/**
		 * Optional parameters for the current interceptor.
		 */
		protected var _parameters:Object;

		/**
		 * Creates a new AbstractInterceptor object.
		 */
		public function AbstractInterceptor() {
			super();
		}

		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable#dispose();
		 */
		override public function dispose():void {
			notification = null;
			processor = null;
			
			super.dispose();
		}
		
		/**
		 * Abstract implementation of intercept to complete the interface.
		 */
		public function intercept():void {
			
		}

		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IInterceptor#proceed();
		 */
		public function proceed(note:INotification = null):void {
			processor.proceed(note != null ? note : notification);
		}

		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IInterceptor#abort();
		 */
		public function abort():void {
			processor.abort();
		}

		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IInterceptor#skip();
		 */
		public function skip():void {
			processor.skip();
		}

		/**
		 * The notification object to intercept.
		 */
		public function get notification():INotification {
			return _notification;
		}

		/**
		 * @private
		 */
		public function set notification(notification:INotification):void {
			_notification = notification;
		}

		/**
		 * The notification processor that will control this interception.
		 */
		public function get processor():NotificationProcessor {
			return _processor;
		}

		/**
		 * @private
		 */
		public function set processor(processor:NotificationProcessor):void {
			_processor = processor;
		}
		
		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IInterceptor#parameters;
		 */
		public function get parameters():Object {
			return _parameters;
		}
		
		/**
		 * @private
		 */
		public function set parameters(parameters:Object):void {
			_parameters = parameters;
		}
	}
}
