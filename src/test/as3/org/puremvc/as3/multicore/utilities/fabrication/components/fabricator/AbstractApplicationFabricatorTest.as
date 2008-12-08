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
	import org.puremvc.as3.multicore.utilities.fabrication.components.empty.EmptyFlexModuleStartupCommand;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IMockable;
	import org.puremvc.as3.multicore.utilities.fabrication.routing.Router;
	
	import com.anywebcam.mock.Mock;
	
	import flexunit.framework.SimpleTestCase;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class AbstractApplicationFabricatorTest extends SimpleTestCase {

		static public var dependency:EmptyFlexModuleStartupCommand;
		public var fabricator:ApplicationFabricator;
		public var fabrication:IFabrication;
		public var fabricationMock:Mock;
		public var facadeMock:Mock;
		
		public function AbstractApplicationFabricatorTest(method:String) {
			super(method);
		}
		
		override public function setUp():void {
			initializeTestCase();
		}
		
		override public function tearDown():void {
			
		}
		
		public function initializeTestCase():void {
			initializeFabrication();
			initializeFabricationMock();
			
			initializeFabricator();
		}
		
		public function initializeFabrication():void {
			
		}
		
		public function initializeFabricator():void {
			
		}
		
		public function initializeFabricationMock():void {
			fabricationMock = (fabrication as IMockable).mock;
			fabricationMock.ignoreMissing = true;
			
			fabricationMock.property("router").returns(new Router());
			//fabricationMock.method("dispatchEvent").withArgs(Event);
		}

		public function testApplicationFabricatorHasValidType():void {
			assertType(ApplicationFabricator, fabricator);
			assertType(IDisposable, fabricator);
		}
		
	}
}
