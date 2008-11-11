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
 
package org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy {
	import com.anywebcam.mock.Mock;
	
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IMockable;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacade;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class FabricationProxyMock extends FabricationProxy implements IMockable {
		
		static public const NAME:String = "FabricationMockProxy";
		private var _mock:Mock;
		
		public function FabricationProxyMock(name:String = null, data:String = null) {
			super(name, data);
		}
		
		public function get mock():Mock {
			if (_mock == null) {
				_mock = new Mock(this);
			}
			
			return _mock;
		}
	
		override public function dispose():void {
			mock.dispose();
		}
		
		override public function getNotificationName(note:String):String {
			return mock.getNotificationName(note);
		}
		
		override public function getDefaultProxyName():String {
			return mock.getDefaultProxyName();
		}
		
		override public function sendNotification(noteName:String, noteBody:Object = null, noteType:String = null):void {
			mock.sendNotification(noteName, noteBody, noteType);
		}
		
		override public function routeNotification(noteName:Object, noteBody:Object = null, noteType:String = null, to:Object = null):void {
			mock.routeNotification(noteName, noteBody, noteType, to);
		}
		
		override public function initializeNotifier(key:String):void {
			mock.initializeNotifier(key);
			super.initializeNotifier(key);
		}
		
		override protected function initializeProxyNameCache():void {
			mock.initializeProxyNameCache();
		}
		
		override protected function get fabFacade():FabricationFacade {
			return mock.fabFacade;
		}
		
		override protected function hasCachedDefaultProxyName():Boolean {
			return mock.hasCachedDefaultProxyName();
		}
		
		override protected function getCachedDefaultProxyName():String {
			return mock.getCachedDefaultProxyName();
		}
		
		// Proxy mocks
		override public function getProxyName():String {
			return mock.getProxyName();
		}
		
		override public function setData(data:Object):void {
			mock.setData(data);
		}
		
		override public function getData():Object {
			return mock.getData();
		}
		
		override public function onRegister():void {
			mock.onRegister();
		}
		
		override public function onRemove():void {
			mock.onRemove();
		}
		
	}
}
