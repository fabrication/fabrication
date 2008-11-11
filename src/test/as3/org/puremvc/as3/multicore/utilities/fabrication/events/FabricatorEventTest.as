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
 
package org.puremvc.as3.multicore.utilities.fabrication.events {
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;	
	
	import flexunit.framework.SimpleTestCase;	
	
	/**
	 * @author Darshan Sawardekar
	 */
	public class FabricatorEventTest extends SimpleTestCase {
		
		private var fabricatorEvent:FabricatorEvent;
		
		public function FabricatorEventTest(method:String) {
			super(method);
		}
		
		override public function setUp():void {
			fabricatorEvent = new FabricatorEvent(FabricatorEvent.FABRICATION_CREATED);
		}
		
		override public function tearDown():void {
			fabricatorEvent.dispose();
			fabricatorEvent = null;
		}

		public function testInstantiation():void {
			assertType(FabricatorEvent, fabricatorEvent);
		}
		
		public function testFabricatorEventHasCreatedType():void {
			assertNotNull(FabricatorEvent.FABRICATION_CREATED);
		}
		
		public function testFabricatorEventHasRemovedType():void {
			assertNotNull(FabricatorEvent.FABRICATION_REMOVED);
		}
		
		public function testFabricatorEventStoresCreatedType():void {
			var event:FabricatorEvent = new FabricatorEvent(FabricatorEvent.FABRICATION_CREATED);
			assertEquals(FabricatorEvent.FABRICATION_CREATED, event.type);	
		}
		
		public function testFabricatorEventStoresRemovedType():void {
			var event:FabricatorEvent = new FabricatorEvent(FabricatorEvent.FABRICATION_REMOVED);
			assertEquals(FabricatorEvent.FABRICATION_REMOVED, event.type);
		}
		
		public function testFabricatorEventIsDisposable():void {
			assertType(IDisposable, fabricatorEvent);
		}
		
	}
}
