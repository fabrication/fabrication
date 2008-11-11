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
 
package org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class ModuleListLoader extends EventDispatcher {
		
		static public var instance:ModuleListLoader;
		
		static public function getInstance():ModuleListLoader {
			if (instance == null) {
				instance = new ModuleListLoader();
			}
			
			return instance;
		}

		public var timeoutMS:int = 5000;
		public var configLoader:URLLoader;
		public var configXml:XML;
		public var base:String;
		public var modules:Array = new Array();
		
		public function ModuleListLoader() {
			super();
		}
		
		public function load(configUrl:String):void {
			configLoader = new URLLoader();
			configLoader.addEventListener(Event.COMPLETE, completeListener);
			configLoader.load(new URLRequest(configUrl));
		}
		
		public function completeListener(event:Event):void {
			configLoader.removeEventListener(Event.COMPLETE, completeListener);
			
			configXml = new XML(configLoader.data);
			base = configXml.@base;
			
			var modulesXML:XMLList = configXml..module;
			var n:int = modulesXML.length();
			var module:XML;
			
			for (var i:int = 0; i < n; i++) {
				module = modulesXML[i];
				modules.push(base + module.@path);
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}
}
