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
 
package org.puremvc.as3.multicore.utilities.fabrication.core {
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.undoable.SimpleUndoableCommand;	
	
	import flexunit.framework.SimpleAssert;
	import flexunit.framework.SimpleTestCase;
	
	import com.anywebcam.mock.Mock;
	
	import org.puremvc.as3.multicore.core.Controller;
	import org.puremvc.as3.multicore.core.View;
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.interfaces.IObserver;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.utilities.fabrication.core.FabricationViewMock;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IUndoableCommand;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mock.SimpleFabricationCommandMock;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mock.SimpleFabricationCommandMock1;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mock.SimpleFabricationCommandMock2;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mock.SimpleFabricationCommandMock3;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mock.SimpleFabricationCommandMock4;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mock.SimpleFabricationCommandMock5;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mock.SimpleUndoableCommandMock;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mock.SimpleUndoableCommandMock1;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mock.SimpleUndoableCommandMock2;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mock.SimpleUndoableCommandMock3;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mock.SimpleUndoableCommandMock4;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mock.SimpleUndoableCommandMock5;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.UndoableNotification;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;		

	/**
	 * @author Darshan Sawardekar
	 */
	public class FabricationControllerTest extends SimpleTestCase {

		private var controller:FabricationController = null;
		private var classesToLink:Array = [
			SimpleUndoableCommandMock1,
			SimpleUndoableCommandMock2,
			SimpleUndoableCommandMock3,
			SimpleUndoableCommandMock4,
			SimpleUndoableCommandMock5,
		];

		public function FabricationControllerTest(method:String) {
			super(method);
		}

		override public function setUp():void {
			controller = new FabricationController(methodName);
		}

		override public function tearDown():void {
			controller.dispose();
			controller = null;
		}

		public function testFabricationControllerHasValidType():void {
			assertType(FabricationController, controller);
			assertType(Controller, controller);
			assertType(IDisposable, controller);
		}
		
		public function testFabricationControllerAllowsRegisteringCommands():void {
			var note:INotification = new Notification(methodName, 
				function(mock:Mock):Boolean {
					mock.method("execute").withArgs(note).once;
					return true;
				}
			);
			
			controller.registerCommand(note.getName(), SimpleFabricationCommandMock);
			controller.executeCommand(note);
		}
		
		public function testFabricationControllerAllowsRemovingCommands():void {
			var count:int = 0;
			var note:INotification = new Notification(methodName, 
				function(mock:Mock):Boolean {
					mock.method("execute").withArgs(note).never;
					count++;
					return true;
				}
			);
			
			controller.registerCommand(note.getName(), SimpleFabricationCommandMock);
			controller.removeCommand(note.getName());
			controller.executeCommand(note);

			assertEquals(0, count);			
		}
		
		public function testFabricationControllerAllowsRegisteringMultipleCommandsWithTheSameNotification():void {
			var sampleSize:int = 6;
			var callCount:int = 0;
			var note:INotification = new Notification(methodName, 
				function(mock:Mock):Boolean {
					callCount++;
					mock.method("execute").withArgs(note).once;
					return true;
				}
			);
			
			controller.registerCommand(note.getName(), SimpleFabricationCommandMock);
			controller.registerCommand(note.getName(), SimpleFabricationCommandMock1);
			controller.registerCommand(note.getName(), SimpleFabricationCommandMock2);
			controller.registerCommand(note.getName(), SimpleFabricationCommandMock3);
			controller.registerCommand(note.getName(), SimpleFabricationCommandMock4);
			controller.registerCommand(note.getName(), SimpleFabricationCommandMock5);
			
			controller.executeCommand(note);
			
			assertEquals(sampleSize, callCount);
		}
		
		public function testFabricationControllerAllowsRemovingIndividualCommands():void {
			var callCount:int = 0;
			var note:INotification = new Notification(methodName, 
				function(mock:Mock):Boolean {
					callCount++;
					mock.method("execute").withArgs(note).never;
					return true;
				}
			);
			
			controller.registerCommand(note.getName(), SimpleFabricationCommandMock);
			controller.registerCommand(note.getName(), SimpleFabricationCommandMock1);
			controller.registerCommand(note.getName(), SimpleFabricationCommandMock2);
			controller.registerCommand(note.getName(), SimpleFabricationCommandMock3);
			controller.registerCommand(note.getName(), SimpleFabricationCommandMock4);
			controller.registerCommand(note.getName(), SimpleFabricationCommandMock5);
			
			controller.removeSingleCommand(note.getName(), SimpleFabricationCommandMock);
			assertTrue(controller.hasCommand(note.getName()));
			
			controller.removeSingleCommand(note.getName(), SimpleFabricationCommandMock1);
			assertTrue(controller.hasCommand(note.getName()));
			
			controller.removeSingleCommand(note.getName(), SimpleFabricationCommandMock2);
			assertTrue(controller.hasCommand(note.getName()));
			
			controller.removeSingleCommand(note.getName(), SimpleFabricationCommandMock3);
			assertTrue(controller.hasCommand(note.getName()));
			
			controller.removeSingleCommand(note.getName(), SimpleFabricationCommandMock4);
			assertTrue(controller.hasCommand(note.getName()));
			
			controller.removeSingleCommand(note.getName(), SimpleFabricationCommandMock5);
			assertFalse(controller.hasCommand(note.getName()));
			
			controller.executeCommand(note);
			
			assertEquals(0, callCount);
		}
		
		public function testFabricationControllerUndoRedoExecutionOrderIsValid():void {
			var mockPath:String = getQualifiedClassName(SimpleUndoableCommandMock);
			mockPath = mockPath.replace(new RegExp("(::.*)", ""), "");
			
			var repeatCount:int = 10;
			var sampleSize:int = 5;
			var i:int = 0;
			var commandClass:Class;
			var expectedOrder:Array = new Array();
			var actualOrder:Array = new Array();
			
			for (i = 1; i <= sampleSize; i++) {
				commandClass = getDefinitionByName(mockPath + ".SimpleUndoableCommandMock" + i) as Class;
				controller.registerCommand("note" + i, commandClass);
				expectedOrder.push(mockPath + "::SimpleUndoableCommandMock" + i);
			}
			
			for (i = 1; i <= sampleSize; i++) {
				controller.executeCommand(createNotification("note" + i, actualOrder));
			}			

			assertArrayEquals(expectedOrder, actualOrder);
			
			for (i = 0; i < repeatCount; i++) {
				// for undo the expected order is reverse of the execution order
				expectedOrder.reverse();			
				actualOrder.splice(0);
				
				assertTrue(controller.canUndo());
				controller.undo(sampleSize);
				assertFalse(controller.canUndo());
				
				assertArrayEquals(expectedOrder, actualOrder);
				
				// with redo the expected order is the original order
				expectedOrder.reverse();
				actualOrder.splice(0);
				
				assertTrue(controller.canRedo());
				controller.redo(sampleSize);
				assertFalse(controller.canRedo());
				
				assertArrayEquals(expectedOrder, actualOrder);
			}
		}
		
		public function testFabricationControllerHasValidUndoRedoSizes():void {
			var mockPath:String = getQualifiedClassName(SimpleUndoableCommandMock);
			mockPath = mockPath.replace(new RegExp("(::.*)", ""), "");
			
			var repeatCount:int = 10;
			var sampleSize:int = 5;
			var i:int = 0;
			var commandClass:Class;
			
			for (i = 1; i <= sampleSize; i++) {
				commandClass = getDefinitionByName(mockPath + ".SimpleUndoableCommandMock" + i) as Class;
				controller.registerCommand("note" + i, commandClass);
			}
			
			for (i = 1; i <= sampleSize; i++) {
				controller.executeCommand(createNotification("note" + i, []));
			}			

			assertEquals(sampleSize, controller.undoSize());
			
			for (i = 0; i < repeatCount; i++) {
				assertEquals(sampleSize, controller.undoSize());
				controller.undo(sampleSize);
				assertEquals(0, controller.undoSize());
				assertFalse(controller.canUndo());
				
				assertEquals(sampleSize, controller.redoSize());
				controller.redo(sampleSize);
				assertEquals(0, controller.redoSize());
				assertFalse(controller.canRedo());
			}
		}
		
		public function testFabricationControllerUndoRedoExecutionOrderIsValidWithoutStepSize():void {
			var mockPath:String = getQualifiedClassName(SimpleUndoableCommandMock);
			mockPath = mockPath.replace(new RegExp("(::.*)", ""), "");
			
			var repeatCount:int = 10;
			var sampleSize:int = 5;
			var i:int = 0;
			var j:int = 0;
			var commandClass:Class;
			var expectedOrder:Array = new Array();
			var actualOrder:Array = new Array();
			
			for (i = 1; i <= sampleSize; i++) {
				commandClass = getDefinitionByName(mockPath + ".SimpleUndoableCommandMock" + i) as Class;
				controller.registerCommand("note" + i, commandClass);
				expectedOrder.push(mockPath + "::SimpleUndoableCommandMock" + i);
			}
			
			for (i = 1; i <= sampleSize; i++) {
				controller.executeCommand(createNotification("note" + i, actualOrder));
			}			

			assertArrayEquals(expectedOrder, actualOrder);
			
			for (i = 0; i < repeatCount; i++) {
				// for undo the expected order is reverse of the execution order
				expectedOrder.reverse();			
				actualOrder.splice(0);
				
				assertTrue(controller.canUndo());
				for (j = 0; j < sampleSize; j++) {
					controller.undo();
				}
				assertFalse(controller.canUndo());
				
				assertArrayEquals(expectedOrder, actualOrder);
				
				// with redo the expected order is the original order
				expectedOrder.reverse();
				actualOrder.splice(0);
				
				assertTrue(controller.canRedo());
				for (j = 0; j < sampleSize; j++) {
					controller.redo(sampleSize);
				}
				assertFalse(controller.canRedo());
				
				assertArrayEquals(expectedOrder, actualOrder);
			}
		}
		
		public function testFabricationControllerMergesCommandsWhenPossible():void {
			var mockPath:String = getQualifiedClassName(SimpleUndoableCommandMock);
			mockPath = mockPath.replace(new RegExp("(::.*)", ""), "");
			
			var repeatCount:int = 10;
			var sampleSize:int = 5;
			var i:int = 0;
			var commandClass:Class;
			
			for (i = 1; i <= sampleSize; i++) {
				commandClass = getDefinitionByName(mockPath + ".SimpleUndoableCommandMock" + i) as Class;
				controller.registerCommand("note" + i, commandClass);
			}
			
			for (i = 1; i <= sampleSize; i++) {
				controller.executeCommand(createNotification("note" + i, [], true));
			}			

			assertEquals(1, controller.undoSize());
			
			for (i = 0; i < repeatCount; i++) {
				assertEquals(1, controller.undoSize());
				controller.undo();
				assertEquals(0, controller.undoSize());
				assertFalse(controller.canUndo());
				
				assertEquals(1, controller.redoSize());
				controller.redo();
				assertEquals(0, controller.redoSize());
				assertFalse(controller.canRedo());
			}
		}
		
		public function testFabricationControllerTrimsRedoStackAfterIntermittentCommandInsertion():void {
			var mockPath:String = getQualifiedClassName(SimpleUndoableCommandMock);
			mockPath = mockPath.replace(new RegExp("(::.*)", ""), "");
			
			var sampleSize:int = 5;
			var i:int = 0;
			var commandClass:Class;
			var expectedOrder:Array = new Array();
			var actualOrder:Array = new Array();
			
			for (i = 1; i <= sampleSize; i++) {
				commandClass = getDefinitionByName(mockPath + ".SimpleUndoableCommandMock" + i) as Class;
				controller.registerCommand("note" + i, commandClass);
				expectedOrder.push(mockPath + "::SimpleUndoableCommandMock" + i);
			}
			
			for (i = 1; i <= sampleSize; i++) {
				controller.executeCommand(createNotification("note" + i, actualOrder));
			}			

			assertArrayEquals(expectedOrder, actualOrder);
			
			controller.undo(2);
			assertEquals(3, controller.undoSize());
			assertEquals(2, controller.redoSize());

			controller.executeCommand(createNotification("note1", actualOrder));
			assertEquals(4, controller.undoSize());
			assertEquals(0, controller.redoSize());
			assertFalse(controller.canRedo());
		}
		
		public function testFabricationControllerSendsNotificationWhenUndoRedoStackChanges():void {
			var repeatCount:int = 10;
			var sampleSize:int = 5;
			var expectedNote:INotification;
			var i:int = 0;
			var j:int = 0;
			var commandClass:Class;
			var mockPath:String = getQualifiedClassName(SimpleUndoableCommandMock);
			mockPath = mockPath.replace(new RegExp("(::.*)", ""), "");
			
			var view:FabricationViewMock = FabricationViewMock.getInstance("X" + methodName);
			assertType(FabricationViewMock, view);
			assertType(View, view);
			assertNotNull(view.mock);

			view.mock.method("notifyObservers").withArgs(
				function(note:UndoableNotification):Boolean {
					assertType(INotification, note);
					assertType(UndoableNotification, note);
					assertType(Boolean, note.undoable);
					assertType(Boolean, note.redoable);
					assertType(Array, note.undoableCommands);
					assertType(Array, note.redoableCommands);
					
					if (note.undoable) {
						assertType(String, note.undoCommand);						
					}
					
					if (note.redoable) {
						assertType(String, note.redoCommand);
					}
					
					return true;
				}
			).exactly(sampleSize + (repeatCount*2) + (repeatCount*sampleSize*2));
			
			var controller:FabricationController = new FabricationController("X" + methodName);
			
			for (i = 1; i <= sampleSize; i++) {
				commandClass = getDefinitionByName(mockPath + ".SimpleUndoableCommandMock" + i) as Class;
				
				view.mock.method("registerObserver").withArgs("note" + i, IObserver);
				controller.registerCommand("note" + i, commandClass);
			}
			
			for (i = 1; i <= sampleSize; i++) {
				expectedNote = createNotification("note" + i, []);
				controller.executeCommand(expectedNote);
			}
			
			for (i = 0; i < repeatCount; i++) {
				assertTrue(controller.undo(sampleSize));
				assertTrue(controller.redo(sampleSize));
				
				for (j = 0; j < sampleSize; j++) {
					assertTrue(controller.undo());
				}
				assertFalse(controller.undo());
				
				for (j = 0; j < sampleSize; j++) {
					assertTrue(controller.redo());
				}
				assertFalse(controller.redo());
			}			

			verifyMock(view.mock);
		}
		
		public function testFabricationControllerResetsAfterDisposal():void {
			var controller:FabricationController = new FabricationController("X" + methodName);
			controller.dispose();
			
			assertThrows(Error);
			controller.undo();
			controller.redo();
			controller.registerCommand(null, null);
			controller.executeCommand(null);
		}
		
		public function createNotification(name:String, orderList:Array, merge:Boolean = false):INotification {
			var note:INotification = new Notification(name, 
				function(mock:Mock):Boolean {
					orderList.push(getQualifiedClassName(mock.target));
					
					if (!mock.target.mockInjected) {					
						var name:String = SimpleAssert.getClassName(mock.target);
						
						mock.method("getNotification").withNoArgs.returns(note);
						mock.method("getDescription").withNoArgs.returns(name);
						mock.method("getPresentationName").withNoArgs.returns(name);
						mock.method("getUndoPresentationName").withNoArgs.returns("Undo " + name);
						mock.method("getRedoPresentationName").withNoArgs.returns("Redo " + name);
						mock.method("merge").withArgs(IUndoableCommand).returns(merge);
						
						mock.method("execute").withArgs(note);
						mock.method("unexecute").withArgs(note);
					}
					
					return true;
				}
			);
			
			return note;
		}
		
		public function testFabricationControllerCanDirectlyExecuteICommandsWithoutBodyOrNotification():void {
			var command:ICommand = controller.executeCommandClass(SimpleFabricationCommandMock);
			assertType(ICommand, command);
			assertTrue(command["executed"]);
		}
		
		public function testFabricationControllerCanDirectlyExecuteICommandWithOnlyBodyOfNotification():void {
			var body:Object = new Object();
			var command:ICommand = controller.executeCommandClass(SimpleFabricationCommandMock, body);
			assertType(ICommand, command);
			assertEquals(body, command["executedNote"].getBody());
		}
		
		public function testFabricationControllerCanDirectlyExecuteICommandsWithSpecifiedNotification():void {
			var note:Notification = new Notification("x", "y", "z");
			var command:ICommand = controller.executeCommandClass(SimpleFabricationCommandMock, null, note);
			
			assertType(ICommand, command);
			assertEquals(note, command["executedNote"]);
		}
		
		public function testFabricationControllerCanDirectlyExecuteUndoableCommands():void {
			var note:Notification = new Notification("x", "y", "z");
			var command:ICommand = controller.executeCommandClass(SimpleUndoableCommand, null, note);
			
			assertType(IUndoableCommand, command);
			assertEquals(note, (command as IUndoableCommand).getNotification());
		}
		
	}
}
