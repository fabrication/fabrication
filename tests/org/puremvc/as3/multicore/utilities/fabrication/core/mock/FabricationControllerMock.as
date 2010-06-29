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
 
package org.puremvc.as3.multicore.utilities.fabrication.core.mock {
    import com.anywebcam.mock.Mock;

    import org.puremvc.as3.multicore.interfaces.ICommand;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.utilities.fabrication.addons.IMockable;
    import org.puremvc.as3.multicore.utilities.fabrication.core.*;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IUndoableCommand;

    /**
	 * @author Darshan Sawardekar
	 */
	public class FabricationControllerMock extends FabricationController implements IMockable {

		private var _mock:Mock;
		
		static public function getInstance(key:String):FabricationControllerMock {
			if (instanceMap[key] == null) {
				instanceMap[key] = new FabricationControllerMock(key);
			}
			
			return instanceMap[key] as FabricationControllerMock;
		}
		
		public function get mock():Mock {
			if (_mock == null) {
				_mock = new Mock(this, true);
			};
			
			return _mock;
		}
		
		public function FabricationControllerMock(key:String) {
			super(key);
		}
		
		override public function dispose():void {
			mock.dispose();
		}
		
		override public function registerCommand(notificationName:String, clazz:Class):void {
			mock.registerCommand(notificationName, clazz);
		}
		
		override public function executeCommand(note:INotification):void {
			mock.executeCommand(note);
		}
		
		override public function removeSingleCommand(notificationName:String, clazz:Class):void {
			mock.removeSingleCommand(notificationName, clazz);
		}
		
		override public function canUndo():Boolean {
			return mock.canUndo();
		}
		
		override public function canRedo():Boolean {
			return mock.canRedo();
		}
		
		override public function undo(steps:int = 1):Boolean {
			return mock.undo(steps);
		}
		
		override public function redo(steps:int = 1):Boolean {
			return mock.redo(steps);
		}
		
		override protected function addCommand(command:IUndoableCommand):void {
			mock.addCommand(command);
		}
		
		override protected function unexecuteCommand(command:IUndoableCommand, note:INotification):void {
			mock.unexecuteCommand(command, note);
		}
		
		override protected function notifyCommandHistoryChanged():void {
			mock.notifyCommandHistoryChanged();
		}
		
		// Controller Mocks
		override protected function initializeController():void {
			mock.initializeController();
		}
		
		override public function hasCommand(notificationName:String):Boolean {
			return mock.hasCommand(notificationName);
		}
		
		override public function executeCommandClass(clazz:Class, body:Object = null, note:INotification = null):ICommand {
			return mock.executeCommandClass(clazz, body, note);
		}
		
		override public function registerInterceptor(note:String, clazz:Class, parameters:Object = null):void {
			mock.registerInterceptor(note, clazz, parameters);
		}
		
		override public function removeInterceptor(note:String, clazz:Class = null):void {
			mock.removeInterceptor(note, clazz);
		}
		
		override public function intercept(note:INotification):Boolean {
			return mock.intercept(note);
		}
		
		override public function hasInterceptor(note:String):Boolean {
			return mock.hasInterceptor(note);
		}
		
		override public function get fabricationView():FabricationView {
			return mock.fabricationView;
		}
		
		override public function get groupID():String {
			return mock.groupID;
		}
		
		override public function set groupID(groupID:String):void {
			mock.groupID = groupID;
		}
		
	}
}
