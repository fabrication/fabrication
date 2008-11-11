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
	import flexunit.framework.SimpleTestCase;
	
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;
	
	import flash.events.Event;		

	/**
	 * @author Darshan Sawardekar
	 */
	public class MediatorRegistrarEventTest extends SimpleTestCase {
		
		private var mediatorRegistrarEvent:MediatorRegistrarEvent = null;
		
		public function MediatorRegistrarEventTest(method:String) {
			super(method);
		}
		
		override public function setUp():void {
			mediatorRegistrarEvent = new MediatorRegistrarEvent(MediatorRegistrarEvent.REGISTRATION_COMPLETED, new FlexMediator("foo", null));
		}
		
		override public function tearDown():void {
			mediatorRegistrarEvent.dispose();
			mediatorRegistrarEvent = null;
		}
		
		public function testInstantiation():void {
			assertType(MediatorRegistrarEvent, mediatorRegistrarEvent);
			assertType(Event, mediatorRegistrarEvent);
			assertType(IDisposable, mediatorRegistrarEvent);
		}
		
		public function testMediatorRegistrarEventHasCompletedType():void {
			assertNotNull(MediatorRegistrarEvent.REGISTRATION_COMPLETED);
			assertType(String, MediatorRegistrarEvent.REGISTRATION_COMPLETED);
		}
		
		public function testMediatorRegistrarEventHasCanceledType():void {
			assertNotNull(MediatorRegistrarEvent.REGISTRATION_CANCELED);
			assertType(String, MediatorRegistrarEvent.REGISTRATION_CANCELED);
		}
		
		public function testMediatorRegistrarEventStoresType():void {
			assertEquals(MediatorRegistrarEvent.REGISTRATION_COMPLETED, mediatorRegistrarEvent.type);
		}
		
		public function testMediatorRegistrarEventStoresMediator():void {
			var mediator:FlexMediator = new FlexMediator("test", null);
			var mediatorRegistrarEvent:MediatorRegistrarEvent = new MediatorRegistrarEvent(MediatorRegistrarEvent.REGISTRATION_COMPLETED, mediator);
			
			assertEquals(mediator, mediatorRegistrarEvent.mediator);
			assertType(FlexMediator, mediatorRegistrarEvent.mediator);
		}
		
		public function testMediatorRegistrarEventResetsAfterDisposal():void {
			mediatorRegistrarEvent = new MediatorRegistrarEvent(MediatorRegistrarEvent.REGISTRATION_COMPLETED, new FlexMediator("foo", null));
			mediatorRegistrarEvent.dispose();
			
			assertNull(mediatorRegistrarEvent.mediator);
			assertThrows(Error);
			mediatorRegistrarEvent.mediator.getMediatorName();
		}
	}
}
