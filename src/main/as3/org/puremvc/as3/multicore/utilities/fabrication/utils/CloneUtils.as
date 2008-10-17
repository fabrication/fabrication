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
	 * Miscellaneous utilites to assist with cloning an object with reflection.
	 *  
	 * @author Darshan Sawardekar
	 */
	public class CloneUtils {

		/**
		 * Creates an instance of the specified class and returns it. 
		 * Since it is not possible to perform instantiation with dynamic
		 * constructor parameters, this is a reasonable approximation.
		 * 
		 * @param clazz Reference to the class to instantiate
		 * @param params The number of parameters required by the class constructor. 
		 */
		static public function newInstance(clazz:Class, params:int = 0):Object {
			var instance:Object;
			
			switch (params) {
			
				case 0:
					instance = new clazz();
					break;
					
				case 1:
					instance = new clazz(null);
					break;
					
				case 2:
					instance = new clazz(null, null);
					break;
					
				case 3:
					instance = new clazz(null, null, null);
					break;
					
				case 4:
					instance = new clazz(null, null, null, null);
					break;
					
				case 5:
					instance = new clazz(null, null, null, null, null);
					break;
					
					// Assumes that any additional arguments are optional arguments
					
				default:
					instance = new clazz();	
			}

			return instance;			
		}
	}
}
