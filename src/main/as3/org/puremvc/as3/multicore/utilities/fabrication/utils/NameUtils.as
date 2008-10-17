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
 
package org.puremvc.as3.multicore.utilities.fabrication.utils {

	/**
	 * NameUtils provides unique name generation based on a 
	 * base name string.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class NameUtils {
		
		/**
		 * Stores the base names and their counters
		 */
		static private var namesMap:Object = new Object();
		
		/**
		 * Calculates the next name for the specified base name
		 * and increments the previous counter for the base name.
		 */
		static public function nextName(name:String):String {
			var nameObj:String = namesMap[name];
			if (nameObj == null) {
				nameObj = namesMap[name] = 0;
			} else {
				namesMap[name]++;
			}
			
			return name + namesMap[name];
		}
		
	}
}
