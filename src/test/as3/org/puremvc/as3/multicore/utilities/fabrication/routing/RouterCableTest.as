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
 
package org.puremvc.as3.multicore.utilities.fabrication.routing {
	import flexunit.framework.SimpleTestCase;
	
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterCable;
	import org.puremvc.as3.multicore.utilities.fabrication.plumbing.NamedPipe;		

	/**
	 * @author Darshan Sawardekar
	 */
	public class RouterCableTest extends SimpleTestCase {
		
		private var routerCable:RouterCable = null;
		
		public function RouterCableTest(method:String) {
			super(method);
		}
		
		override public function setUp():void {
			routerCable = new RouterCable(new NamedPipe("input"), new NamedPipe("output"));
		}
		
		override public function tearDown():void {
			routerCable.dispose();
			routerCable = null;
		}
		
		public function testRouterCableHasValidType():void {
			assertType(RouterCable, routerCable);
			assertType(IRouterCable, routerCable);
			assertType(IDisposable, routerCable);
		}
		
		public function testRouterCableStoresInputPipe():void {
			assertType(NamedPipe, routerCable.getInput());
			assertEquals("input", routerCable.getInput().getName());
		}
		
		public function testRouterCableStoresOutputPipe():void {
			assertType(NamedPipe, routerCable.getOutput());
			assertEquals("output", routerCable.getOutput().getName());
		}
		
	}
}
