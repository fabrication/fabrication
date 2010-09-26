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
	
	/**
	 * The FabricatorEvent class represents event objects related to
	 * the application fabrication creation and removal.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class FabricatorEvent extends Event implements IDisposable {

		/**
		 * Dispatched when the fabrication creation is complete.
		 */
		static public const FABRICATION_CREATED:String = "fabricationCreated";
		
		/**
		 * Dispatched when the fabrication removal is complete.
		 */
		static public const FABRICATION_REMOVED:String = "fabricationRemoved";
		
		/**
		 * Creates a new FabricatorEvent object.
		 */
		public function FabricatorEvent(type:String) {
			super(type);
		}
		
		/**
         * @inheritDoc
         */
		public function dispose():void {
			
		}
		
	}
}
