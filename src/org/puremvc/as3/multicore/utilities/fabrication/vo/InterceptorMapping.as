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
 
package org.puremvc.as3.multicore.utilities.fabrication.vo {
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;	
	
	/**
	 * Stores the details of an interceptor-to-notename mapping.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class InterceptorMapping implements IDisposable {

		/**
		 * The name of the notification to intercept
		 */		
		public var noteName:String;
		
		/**
		 * The interceptor class reference.
		 */
		public var clazz:Class;
		
		/**
		 * Optional parameters to assign to the instance of the interceptor class.
		 */
		public var parameters:Object;
	
		/**
		 * Creates a new InterceptorMapping object.
		 */
		public function InterceptorMapping(noteName:String, clazz:Class, parameters:Object = null) {
			this.noteName = noteName;
			this.clazz = clazz;
			this.parameters = parameters;
		}
	
		/**
         * @inheritDoc
         */
		public function dispose():void {
			noteName = null;
			clazz = null;
			parameters = null;
		}
		
		
	}
}
