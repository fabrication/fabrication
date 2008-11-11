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
 
package org.puremvc.as3.multicore.utilities.fabrication.patterns.command {
	import flexunit.framework.SimpleTestCase;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.utilities.fabrication.components.FabricationMock;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IUndoableCommand;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacadeMock;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class AbstractFabricationCommandTest extends SimpleTestCase {
		
		public var fabrication:FabricationMock;
		public var facade:FabricationFacadeMock;
		public var command:ICommand;
		public var multitonKey:String;
		public var notification:INotification;
		public var uniquenessCount:int = 0;

		public function AbstractFabricationCommandTest(method:String) {
			super(method);
		}
		
		override public function setUp():void {
			multitonKey = methodName + "_mock_facade_" + (uniquenessCount++);
			
			initializeFabrication();
			initializeFacade();
			command = createCommand();
			initializeNotifier();
			notification = createNotification();
			initializeUndoableCommand();
		}
		
		override public function tearDown():void {
			(command as IDisposable).dispose();
			command = null;
			
			facade = null;
		}
		
		public function initializeFabrication():void {
			fabrication = new FabricationMock();
		}
		
		public function initializeFacade():void {
			facade = FabricationFacadeMock.getInstance(multitonKey);
		}

		public function initializeNotifier():void {
			command.initializeNotifier(multitonKey);
		}
		
		public function initializeUndoableCommand():void {
			if (command is IUndoableCommand) {
				(command as IUndoableCommand).initializeUndoableCommand(notification);
			}
		}
		
		public function createCommand():ICommand {
			return null;
		}
		
		public function createNotification():INotification {
			return new Notification("noteName", {body:"noteBody"}, "noteType");
		}
		
		public function get undoCommand():IUndoableCommand {
			return command as IUndoableCommand;
		}
		
		public function executeCommand(notification:INotification = null):void {
			if (notification == null) {
				notification = this.notification;
			}
			
			if (command is IUndoableCommand) {
				(command as IUndoableCommand).initializeUndoableCommand(notification);
			}
			
			command.execute(notification);
		}
		
		public function unexecuteCommand(notification:INotification = null):void {
			if (notification == null) {
				notification = this.notification;
			}
			
			undoCommand.unexecute(notification);
		}
		
		public function testCommandHasValidType():void {
			assertType(ICommand, command);
			assertType(IDisposable, command);
		}
		
	}
}
