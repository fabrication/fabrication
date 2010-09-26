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
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;	
	
	import flash.events.Event;
	
	import mx.core.UIComponent;		

	/**
	 * The ComponentResolverEvent represents an event objects related to
	 * automatic component resolution.
	 *  
	 * @author Darshan Sawardekar
	 */
	public class ComponentResolverEvent extends Event implements IDisposable {

		/**
		 * Dispatched when a component was resolved.
		 */
		static public const COMPONENT_RESOLVED:String = "componentResolved";
		
		/**
		 * Dispatched when a component was desolved after an earlier resolution.
		 */
		static public const COMPONENT_DESOLVED:String = "componentDesolved";
		
		/**
		 * The component that was resolved
		 */
		public var component:UIComponent;
		
		/**
		 * Indicates if the resolution was multimode based.
		 */
		public var multimode:Boolean;
		
		/**
		 * Creates an instance of the ComponentResolverEvent.
		 * 
		 * @param type The event type name
		 * @param component Reference to the component that was resolved.
		 */
		public function ComponentResolverEvent(type:String, component:UIComponent, multimode:Boolean = false) {
			super(type, false, false);
			
			this.component = component;
			this.multimode = multimode;
		}
		
		/**
         * @inheritDoc
         */
		public function dispose():void {
			component = null;
		} 
		
	}
}
