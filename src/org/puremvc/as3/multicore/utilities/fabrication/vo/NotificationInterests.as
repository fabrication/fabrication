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
	 * A value object to store a mediators notification interests and
	 * any qualified prefixes.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class NotificationInterests implements IDisposable {

		/**
		 * The full path to the mediator
		 */	
		public var classpath:String;
		
		/**
		 * The notification interests of the mediator
		 */
		public var interests:Array;
		
		/**
		 * The qualification prefixes of the mediator.
		 */
		public var qualifications:Object;
	
		/**
		 * Creates a new NotificationInterests object.
		 * 
		 * @param classpath The path to the mediator class
		 * @param interests The notification interests of the meditor
		 * @param qualifications The qualification prefixes for the mediator's notifications
		 */
		public function NotificationInterests(classpath:String, interests:Array, qualifications:Object) {
			this.classpath = classpath;
			this.interests = interests;
			this.qualifications = qualifications;
		}
		
		public function dispose():void {
			classpath = null;
			interests = null;
			qualifications = null;
		}
	}
}
