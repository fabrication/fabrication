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
 
package org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator {
	import com.anywebcam.mock.Mock;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IMockable;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class FabricationMediatorTestMock extends FabricationMediator implements IMockable {
		
		static public const NAME:String = "FabricationMediatorTestMock";
		
		private var _mock:Mock;
		
		public function FabricationMediatorTestMock(name:String = null, viewComponent:Object = null):void {
			super(name != null ? name : NAME, viewComponent);
		}
		
		public function get mock():Mock {
			if (_mock == null) {
				_mock = new Mock(this, true);
			}
			
			return _mock;
		}
		
		public function respondToNote(note:Notification):void {
			mock.respondToNote(note);
		}
		
		public function respondToNote1(note:INotification):void {
			mock.respondToNote1(note);
		}
		
		public function respondToNote2(note:INotification):void {
			mock.respondToNote2(note);
		}
		
		public function respondToProxy(note:INotification):void {
			mock.respondToProxy(note);
		}
		
		public function respondToProxy1(note:INotification):void {
			mock.respondToProxy1(note);
		}
		
		public function respondToProxy2(note:INotification):void {
			mock.respondToProxy2(note);
		}
		
		override public function qualifyNotificationInterests():Object {
			return mock.qualifyNotificationInterests();
		}
		
		
	}
}
