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
	import mx.core.UIComponent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.components.FlexModule;
	import org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.intro.DefaultFlexIntroPanel;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;	

	/**
	 * DefaultFlexModuleStartupCommand display intro text if the
	 * startup command class has not been provided by the getStartupCommand
	 * method.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class DefaultFlexModuleStartupCommand extends SimpleFabricationCommand {
		
		/**
		 * Adds the DefaultFlexIntroPanel to the main application with flex
		 * module specific text.
		 */
		override public function execute(note:INotification):void {
			var app:FlexModule = note.getBody() as FlexModule;
			var introPanel:DefaultFlexIntroPanel = new DefaultFlexIntroPanel();
			
			app.percentWidth = 100;
			app.percentHeight = 100;
			
			app.addChildAt(introPanel as UIComponent, 0);
			introPanel.introText.htmlText = "You are seeing this because you haven't provided " +
				"a Startup Command class." +
				"<br/><br/>" +
				"Please provide a reference to your application's startup command class " +
				"by overriding the getStartupCommand()." +
				"<br/><br />" +
				"Modules also need the getClassByName(classpath:String):Class. This method is" +
				"with multi-modular applications that use reflected Mediators";
				
		}
	}
}
