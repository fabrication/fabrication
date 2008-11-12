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
 
package org.puremvc.as3.multicore.utilities.fabrication.core {
	import com.anywebcam.mock.Mock;
	
	import org.puremvc.as3.multicore.core.View;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.interfaces.IObserver;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IMockable;		

	/**
	 * @author Darshan Sawardekar
	 */
	public class FabricationViewMock extends FabricationView implements IMockable {

		public var _mock:Mock;
		
		static public function getInstance(key:String):FabricationViewMock {
			if (instanceMap[key] == null) {
				instanceMap[key] = new FabricationViewMock(key);
			}
			
			return instanceMap[key] as FabricationViewMock;
		}
		
		public function FabricationViewMock(key:String) {
			super(key);			
		}
		
		public function get mock():Mock {
			if (_mock == null) {
				_mock = new Mock(this, true);
			}
			
			return _mock;
		}
		
		override public function dispose():void {
			mock.dispose();
		}
		
		override protected function initializeView():void {
			mock.initializeView();
		}
		
		override public function registerObserver(notificationName:String, observer:IObserver):void {
			mock.registerObserver(notificationName, observer);
		}
		
		override public function notifyObservers(notification:INotification):void {
			mock.notifyObservers(notification);
		}
		
		override public function removeObserver(notificationName:String, notifyContext:Object):void {
			mock.removeObserver(notificationName, notifyContext);
		}
		
		override public function registerMediator(mediator:IMediator):void {
			mock.registerMediator(mediator);
		}
		
		override public function retrieveMediator(mediatorName:String):IMediator {
			return mock.retrieveMediator(mediatorName);
		}
		
		override public function removeMediator(mediatorName:String):IMediator {
			return mock.removeMediator(mediatorName);
		}
		
		override public function hasMediator(mediatorName:String):Boolean {
			return mock.hasMediator(mediatorName);
		}
		
	}
}
