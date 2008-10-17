/**
 * Copyright (C) 2008 Darshan Sawardekar.
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
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;	

	/**
	 * MediatorRegistrarEvent represents the event object related to
	 * mediator registration with the fabricaton facade.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class MediatorRegistrarEvent extends Event {
		
		/**
		 * Dispatched when the mediator registration was completed.
		 */
		static public const REGISTRATION_COMPLETED:String = "registrationCompleted";
		
		/**
		 * Dispatcher when the mediator registration was cancelled.
		 */
		static public const REGISTRATION_CANCELED:String = "registrationCanceled";
		
		/**
		 * The mediator object that was registered
		 */
		public var mediator:FlexMediator;
		
		/**
		 * Creates a new MediatorRegistrarEvent object.
		 * 
		 * @param type The event type name.
		 * @param mediator The mediator object that was registered or cancelled. 
		 */
		public function MediatorRegistrarEvent(type:String, mediator:FlexMediator) {
			super(type);
			
			this.mediator = mediator;
		}
		
	}
}
