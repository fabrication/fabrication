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
 
package org.puremvc.as3.multicore.utilities.fabrication.patterns.command.undoable {
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacade;		

	/**
	 * FabricationRedoCommand performs a redo command operation on the
	 * fabrication facade.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class FabricationRedoCommand extends SimpleFabricationCommand {
		
		/**
		 * Redo's the current operation for the number of steps specified.
		 * Default number of steps to undo is 1.
		 */
		override public function execute(note:INotification):void {
			if (note.getBody() == null) {
				fabFacade.redo();
			} else {
				var steps:int = 1;
				
				if (note.getBody() != null && !isNaN(note.getBody() as int)) {
					steps = note.getBody() as int;
				}
				
				fabFacade.redo(steps);
			}
		}
	}
}
