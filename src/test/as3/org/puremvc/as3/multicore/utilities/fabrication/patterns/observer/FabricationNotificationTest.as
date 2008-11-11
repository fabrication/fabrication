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
 
package org.puremvc.as3.multicore.utilities.fabrication.patterns.observer {
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;	
	
	import flexunit.framework.SimpleTestCase;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import mx.core.Application;		

	/**
	 * @author Darshan Sawardekar
	 */
	public class FabricationNotificationTest extends SimpleTestCase {
		
		private var fabricationNotification:FabricationNotification = null;
		
		public function FabricationNotificationTest(method:String):void {
			super(method);
		}
		
		override public function setUp():void {
			fabricationNotification = new FabricationNotification(FabricationNotification.STARTUP, Application.application, "test");
		}
		
		override public function tearDown():void {
			fabricationNotification.dispose();
			fabricationNotification = null;
		}
		
		public function testInstantiation():void {
			assertType(FabricationNotification, fabricationNotification);
			assertType(INotification, fabricationNotification);
			assertType(IDisposable, fabricationNotification);
		}
		
		public function testFabricationNotificationHasStartupName():void {
			assertNotNull(FabricationNotification.STARTUP);
			assertType(String, FabricationNotification.STARTUP);
		}
		
		public function testFabricationNotificationHasShutdownName():void {
			assertNotNull(FabricationNotification.SHUTDOWN);
			assertType(String, FabricationNotification.SHUTDOWN);
		}
		
		public function testFabricationNotificationHasBootstrapName():void {
			assertNotNull(FabricationNotification.BOOTSTRAP);
			assertType(String, FabricationNotification.BOOTSTRAP);
		}
		
		public function testFabricationNotificationHasUndoName():void {
			assertNotNull(FabricationNotification.UNDO);
			assertType(String, FabricationNotification.UNDO);
		}
		
		public function testFabricationNotificationHasRedoName():void {
			assertNotNull(FabricationNotification.REDO);
			assertType(String, FabricationNotification.REDO);
		}
		
		public function testFabricationNotificationStoresName():void {
			assertEquals(FabricationNotification.STARTUP, fabricationNotification.getName());
			assertType(String, fabricationNotification.getName());
		}
		
		public function testFabricationNotificationStoresBody():void {
			var application:Object = Application.application;
			fabricationNotification = new FabricationNotification(FabricationNotification.STARTUP, application, "test");
			
			assertEquals(application, fabricationNotification.getBody());
		}
		
		public function testFabricationNotificationStoresType():void {
			assertEquals("test", fabricationNotification.getType());
			assertType(String, fabricationNotification.getType());
		}
		
		public function testFabricationNotificationResetsAfterDisposal():void {
			fabricationNotification = new FabricationNotification(FabricationNotification.STARTUP, Application.application, "test");
			fabricationNotification.dispose();
			
			assertNull(fabricationNotification.getBody());
			assertThrows(Error);
			fabricationNotification.getBody().constructor;
		}
	}
}
