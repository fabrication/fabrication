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
 
package flexunit.framework {
	import flexunit.framework.TestContainer;
	
	import mx.events.FlexEvent;
	import mx.events.ModuleEvent;
	import mx.modules.IModuleInfo;
	import mx.modules.Module;
	import mx.modules.ModuleManager;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class ModuleAwareTestCase extends SimpleTestCase {
		
		public var modulesInfoCache:Array = new Array();
		public var moduleDir:String = "";
		public var moduleReadyAsyncHandler:Function;
		public var timeoutMS:int = 25000;
		public var currentModule:Module;
		
		public function ModuleAwareTestCase(method:String) {
			super(method);
		}
		
		public function loadModule(url:String, readyHandler:Function):IModuleInfo {
			url = moduleDir + url;
			
			moduleReadyAsyncHandler = addAsync(readyHandler, timeoutMS);
			
			var moduleInfo:IModuleInfo = ModuleManager.getModule(url);
			moduleInfo.addEventListener(ModuleEvent.READY,
				function(event:ModuleEvent):void {
					var moduleInstance:Module = createModule(event.module);
					moduleInstance.addEventListener(FlexEvent.INITIALIZE, 
						function(event:FlexEvent):void {
							moduleReadyAsyncHandler(event);
						}
					);
					
					addModule(moduleInstance);
				} 
			);
			
			moduleInfo.addEventListener(ModuleEvent.ERROR,
				function(event:ModuleEvent):void {
					try {
						var moduleErrorAsyncHandler:Function = addAsync(moduleLoadErrorHandler, timeoutMS);
						moduleErrorAsyncHandler(event);
					} finally {
						try {
							moduleReadyAsyncHandler(event);
						} catch (error:Error) {
							// no-op
						}
					}
				}
			);
			
			modulesInfoCache.push(moduleInfo);
			moduleInfo.load();
			
			return moduleInfo;
		}
		
		public function createModule(moduleInfo:IModuleInfo):Module {
			var moduleInstance:Module = moduleInfo.factory.create() as Module;
			return moduleInstance;
		}
		
		public function addModule(module:Module):void {
			TestContainer.getInstance().addChild(module);
		}
		
		public function removeModule(module:Module):void {
			TestContainer.getInstance().removeChild(module);
		}
		
		public function moduleLoadErrorHandler(event:ModuleEvent):void {
			fail("Unable to load module for url " + event.module.url);
		}
		
	}
}
