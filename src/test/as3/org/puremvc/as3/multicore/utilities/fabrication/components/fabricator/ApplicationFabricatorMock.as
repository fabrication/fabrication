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
 
package org.puremvc.as3.multicore.utilities.fabrication.components.fabricator {
	import com.anywebcam.mock.Mock;
	
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacadeMock;		

	/**
	 * @author Darshan Sawardekar
	 */
	public class ApplicationFabricatorMock extends ApplicationFabricator {

		public var mock:Mock = null;
		
		public function ApplicationFabricatorMock(_fabrication:IFabrication, mockOptions:Object) {
			super(initializeMock(_fabrication, mockOptions));
		}
		
		public function initializeMock(_fabrication:IFabrication, mockOptions:Object):IFabrication {
			mock = new Mock(this);			
			mock.property("readyEventName").returns(mockOptions.readyEventName);
			
			// the mock facade is created earlier to allow mocks to be setup on it 
			// before hand. These will actually get executed in the init sequence.
			_facade = new FabricationFacadeMock(multitonKey);
			
			
			return _fabrication;
		}
		
		override public function dispose():void {
			super.dispose();
		}
		
		override protected function get readyEventName():String {
			return mock.readyEventName;
		}
		
		override protected function initializeModuleAddress():void {
			mock.initializeModuleAddress();
		}
		
		override protected function initializeFacade():void {
			mock.initializeFacade();
		}

		override protected function initializeEnvironment():void {
			mock.initializeEnvironment();
		}
		
		override protected function startApplication():void {
			mock.startApplication();
			super.startApplication();
		}
		
		override protected function notifyFabricationCreated():void {
			mock.notifyFabricationCreated();
			super.notifyFabricationCreated();
		}
		
		override protected function notifyFabricationRemoved():void {
			mock.notifyFabricationRemoved();
			super.notifyFabricationRemoved();
		}
		
	}
}
