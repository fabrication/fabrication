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
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;		

	/**
	 * This interface allows pipe fittings to have a name. This name
	 * is used to identify the fitting upon retrieval. 
	 * 
	 * @author Darshan Sawardekar
	 */
	public interface INamedPipeFitting extends IPipeFitting {

		/**
		 * Returns the name of the pipe fitting.
		 */
		function getName():String;

		/**
		 * Changes the name of the pipe fitting.
		 * 
		 * @param name The new name of the pipe fitting
		 */
		function setName(name:String):void;
		
		/**
		 * Optional name of the group that this pipe fitting's module belongs to. Default is null
		 * which implies that the module is not part of any group.
		 */
		function get moduleGroup():String;
		
		/**
		 * @private
		 */
		function set moduleGroup(moduleGroup:String):void;
	}
}
