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
 
package org.puremvc.as3.multicore.utilities.fabrication.interfaces {

	/**
	 * An interface to describe how to iterate through a container.
	 * 
	 * @author Darshan Sawardekar
	 */
	public interface IIterator {
	
		/**
		 * Returns a boolean indicating whether there are more items in
		 * the container. 
		 */	
		function hasNext():Boolean;
		
		/**
		 * Returns the next object in the container. 
		 */
		function next():*;
		
	}
}
