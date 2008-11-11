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
	
	import com.anywebcam.mock.Mock;
	
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	import org.puremvc.as3.multicore.utilities.fabrication.routing.RouterMessage;
	import org.puremvc.as3.multicore.utilities.pipes.messages.Message;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class DynamicJunctionTest extends SimpleTestCase {
		
		protected var dynamicJunction:DynamicJunction = null;
		protected var mock:Mock;
		protected var pipe:PipeMock;
		protected var message:RouterMessage;
		
		public function DynamicJunctionTest(method:String) {
			super(method);
		}
		
		override public function setUp():void {
			dynamicJunction = new DynamicJunction();
		}
		
		override public function tearDown():void {
			dynamicJunction.dispose();
			dynamicJunction = null;
		}
		
		protected function verifyDynamicJunctionCanSendMessageWith(destName:String, pipeName:String, fromModuleRoute:String = "A/A0", toModuleRoute:String = "B/B0", message:RouterMessage = null):void {
			if (message == null) {
				message = new RouterMessage(Message.NORMAL, null, fromModuleRoute + "/OUTPUT", toModuleRoute + "/INPUT");
			}
			
			pipe = new PipeMock();
			mock = pipe.mock;
			this.message = message;
			
			mock.method("write").withArgs(message).returns(true);
			dynamicJunction.registerPipe(pipeName, Junction.OUTPUT, pipe);
			
			dynamicJunction.sendMessage(destName, message);
		}
		
		public function testDynamicJunctionHasValidType():void {
			assertType(DynamicJunction, dynamicJunction);
			assertType(Junction, dynamicJunction);
			assertType(IDisposable, dynamicJunction);
		}
		
		public function testDynamicJunctionCanSendMessageToAll():void {
			var fromModuleRoute:String = "A/A0";
			var toModuleName:String = "B";
			var toInstanceName:String;
			
			var pipe:PipeMock;
			var pipeName:String;
			var mock:Mock;
			var i:int = 0;
			var sampleSize:int = 25;
			var pipeList:Array = new Array();
			var message:RouterMessage = new RouterMessage(Message.NORMAL, null, fromModuleRoute + "/OUTPUT");
			
			for (i = 0; i < sampleSize; i++) {
				pipe = new PipeMock();
				mock = pipe.mock;
				toInstanceName = toModuleName + "/" + toModuleName + i;
				pipeName = toInstanceName + "/INPUT";
				
				mock.method("write").withArgs(message).returns(true);
				dynamicJunction.registerPipe(pipeName, Junction.OUTPUT, pipe);
				
				pipeList.push(pipe);
			}
			
			dynamicJunction.sendMessage("*", message);
			
			for (i = 0; i < sampleSize; i++) {
				pipe = pipeList[i];
				assertEquals(message, pipe.message);
			}
		}
		
		public function testDynamicJunctionCanSendMessageToAllInstances():void {
			var fromModuleRoute:String = "A/A0";
			var toModuleName:String = "B";
			var toInstanceName:String;
			
			var pipe:PipeMock;
			var pipeName:String;
			var mock:Mock;
			var i:int = 0;
			var sampleSize:int = 25;
			var pipeList:Array = new Array();
			var message:RouterMessage = new RouterMessage(Message.NORMAL, null, fromModuleRoute + "/OUTPUT");
			
			for (i = 0; i < sampleSize; i++) {
				pipe = new PipeMock();
				mock = pipe.mock;
				toInstanceName = toModuleName + "/" + toModuleName + i;
				pipeName = toInstanceName + "/INPUT";
				
				mock.method("write").withArgs(message).returns(true);
				dynamicJunction.registerPipe(pipeName, Junction.OUTPUT, pipe);
				
				pipeList.push(pipe);
			}
			
			dynamicJunction.sendMessage(toModuleName + "/*", message);
			
			for (i = 0; i < sampleSize; i++) {
				pipe = pipeList[i];
				assertEquals(message, pipe.message);
			}
		}
		
		public function testDynamicJunctionDropsLoopbackMessage():void {
			var fromModuleRoute:String = "A/A0";
			var toModuleRoute:String = fromModuleRoute;
			var destName:String = "*";
			var pipeName:String = toModuleRoute + "/INPUT";
			
			verifyDynamicJunctionCanSendMessageWith(destName, pipeName, fromModuleRoute, toModuleRoute);
			assertNull(message, pipe.message);
		}
		
		public function testDynamicJunctionResetsAfterDisposal():void {
			var dynamicJunction:DynamicJunction = new DynamicJunction();
			dynamicJunction.dispose();
			
			assertThrows(Error);
			dynamicJunction.retrievePipe("test_pipe");
		}
	}
}
