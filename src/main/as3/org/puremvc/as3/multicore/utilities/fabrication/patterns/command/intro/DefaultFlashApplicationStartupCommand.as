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
 
package org.puremvc.as3.multicore.utilities.fabrication.patterns.command.intro {
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.components.FlashApplication;
	import org.puremvc.as3.multicore.utilities.fabrication.components.FlexApplication;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;		

	/**
	 * DefaultFlashApplicationStartupCommand displays intro text if
	 * the startup command class has not been specified in getStartupCommand.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class DefaultFlashApplicationStartupCommand extends SimpleFabricationCommand {
		
		/**
		 * Just shows a trace at the moment. TODO improve this. 
		 */
		override public function execute(note:INotification):void {
			var app:FlashApplication = note.getBody() as FlashApplication;
			
			trace("You are seeing this because you haven't provided " +
				"a Startup Command class.\r" +
				"Please provide a reference to your application's startup command class " +
				"by overriding the getStartupCommand().");
		}
	}
}
