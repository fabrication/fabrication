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

package org.puremvc.as3.multicore.utilities.fabrication.addons {
    import flash.events.Event;

    import mx.events.FlexEvent;
    import mx.events.ModuleEvent;
    import mx.modules.IModuleInfo;
    import mx.modules.Module;
    import mx.modules.ModuleManager;

    import org.flexunit.async.Async;

    /**
     * @author Darshan Sawardekar
     */
    public class ModuleAwareTestCase extends BaseTestCase {

        protected var modulesInfoCache:Array = new Array();
        protected var timeoutMS:int = 25000;
        public var currentModule:Module;
        protected var moduleUrl:String;


        protected function loadModule():void
        {

            var moduleInfo:IModuleInfo = ModuleManager.getModule(moduleUrl);
            modulesInfoCache.push(moduleInfo);
            Async.handleEvent(this, moduleInfo, ModuleEvent.READY, moduleInitializeAsyncHandler, timeoutMS);
            moduleInfo.load();

        }

        protected function moduleInitializeAsyncHandler(event:ModuleEvent, passThroughData:Object = null):void
        {

            var moduleInstance:Module = createModule(event.module);
            assertNotNull(moduleInstance);
            Async.handleEvent( this, moduleInstance, FlexEvent.INITIALIZE, moduleReadyAsyncHandler );
//            moduleInstance.addEventListener(FlexEvent.INITIALIZE, moduleReadyAsyncHandler);
            addModule(moduleInstance);
        }

        protected function moduleReadyAsyncHandler(event:Event, passThroughData:Object = null):void
        {

        }

        private function createModule(moduleInfo:IModuleInfo):Module
        {
            var moduleInstance:Module = moduleInfo.factory.create() as Module;
            return moduleInstance;
        }

        private function addModule(module:Module):void
        {
            try {

                TestContainer.getInstance().add(module);
            }
            catch(e:Error) {

                TestSparkContainer.getInstance().add( module );
            }
        }


    }
}
