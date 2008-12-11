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
 
package org.puremvc.as3.multicore.utilities.fabrication.plumbing {
	import flexunit.framework.SimpleTestCase;
	
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.INamedPipeFitting;
	import org.puremvc.as3.multicore.utilities.pipes.messages.Message;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Pipe;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class NamedPipeTest extends SimpleTestCase {

		private var namedPipe:NamedPipe = null;

		public function NamedPipeTest(method:String) {
			super(method);
		}

		override public function setUp():void {
			namedPipe = new NamedPipe("test");
		}

		override public function tearDown():void {
			namedPipe.dispose();
			namedPipe = null;
		}

		public function testNamedPipeIsValidType():void {
			assertType(NamedPipe, namedPipe);
			assertType(Pipe, namedPipe);
			assertType(INamedPipeFitting, namedPipe);
			assertType(IDisposable, namedPipe);
		}
		
		public function testNamedPipeStoresName():void {
			assertType(String, namedPipe.getName());
			assertEquals("test", namedPipe.getName());
		}
		
		public function testNamedPipeStoresModuleGroup():void {
			assertProperty(namedPipe, "moduleGroup", String, null, "myGroup");
		}
		
		public function testNamedPipeResetsAfterDisposal():void {
			var namedPipe:NamedPipe = new NamedPipe("test_pipe", new Pipe());
			namedPipe.moduleGroup = "myGroup";
			namedPipe.dispose();
			
			assertNull(namedPipe.getName());
			assertNull(namedPipe.moduleGroup);
			assertThrows(Error);
			namedPipe.write(new Message(Message.NORMAL));
		}
	}
}
