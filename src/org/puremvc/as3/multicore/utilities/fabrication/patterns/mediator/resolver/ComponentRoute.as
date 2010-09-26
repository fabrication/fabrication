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
 
package org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver {
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;	
	
	/**
	 * ComponentRoute is a value object to describe the path to a
	 * component in the DisplayObject tree.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class ComponentRoute implements IDisposable {

		/**
		 * The unique id of the component.
		 */
		public var id:String;
		
		/**
		 * The full path to the component.
		 */
		public var path:String;
		
		/**
		 * Creates a new ComponentRoute object.
		 * 
		 * @param id The unique id of the component.
		 * @param path The full path to the component.
		 */
		public function ComponentRoute(id:String, path:String) {
			this.id = id;
			this.path = path;
		}
		
		/**
		 * @inheritDoc
		 */
		public function dispose():void {
			id = null;
			path = null;
		}
		
	}
}
