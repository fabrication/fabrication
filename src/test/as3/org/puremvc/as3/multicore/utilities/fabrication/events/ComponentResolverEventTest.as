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
	
	import mx.core.UIComponent;
	
	import flash.events.Event;		

	/**
	 * @author Darshan Sawardekar
	 */
	public class ComponentResolverEventTest extends SimpleTestCase {
		
		private var componentResolverEvent:ComponentResolverEvent = null;
		
		public function ComponentResolverEventTest(method:String) {
			super(method);
		}
		
		override public function setUp():void {
			componentResolverEvent = new ComponentResolverEvent(ComponentResolverEvent.COMPONENT_RESOLVED, new UIComponent(), true);
		}
		
		override public function tearDown():void {
			componentResolverEvent.dispose();
			componentResolverEvent = null;
		}
		
		public function testInstantiation():void {
			assertType(ComponentResolverEvent, componentResolverEvent);
			assertType(IDisposable, componentResolverEvent);
			assertType(Event, componentResolverEvent);
		} 
		
		public function testComponentResolverEventHasResolvedType():void {
			assertNotNull(ComponentResolverEvent.COMPONENT_RESOLVED);
			assertType(String, ComponentResolverEvent.COMPONENT_RESOLVED);
		}
		
		public function testComponentResolverEventHasDesolvedType():void {
			assertNotNull(ComponentResolverEvent.COMPONENT_DESOLVED);
			assertType(String, ComponentResolverEvent.COMPONENT_DESOLVED);
		}
		
		public function testComponentResolverEventStoresType():void {
			assertEquals(ComponentResolverEvent.COMPONENT_RESOLVED, componentResolverEvent.type);
		}
		
		public function testComponentResolverEventStoresComponent():void {
			var component:UIComponent = new UIComponent();
			componentResolverEvent = new ComponentResolverEvent(ComponentResolverEvent.COMPONENT_RESOLVED, component, true);
			assertEquals(component, componentResolverEvent.component);
			assertType(UIComponent, componentResolverEvent.component);
		}
		
		public function testComponentResolverEventStoresMultimode():void {
			assertType(Boolean, componentResolverEvent.multimode);
			assertEquals(true, componentResolverEvent.multimode);
		}
		
		public function testComponentResolverEventResetsAfterDisposal():void {
			componentResolverEvent = new ComponentResolverEvent(ComponentResolverEvent.COMPONENT_RESOLVED, new UIComponent(), true);
			componentResolverEvent.dispose();
			
			assertNull(componentResolverEvent.component);
			assertThrows(Error);
			componentResolverEvent.component.id;
		}
	}
}
