/**
 * Copyright (C) 2010 Rafał Szemraj.
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

package org.puremvc.as3.multicore.utilities.fabrication.components {
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.system.ApplicationDomain;

    import mx.core.IFlexModuleFactory;
    import mx.events.ModuleEvent;
    import mx.modules.IModuleInfo;
    import mx.modules.ModuleManager;

    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IModuleAddress;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouter;

    /**
     * @inheritDoc
     */
    [Event(name="error", type="mx.events.ModuleEvent")]
    /**
     * @inheritDoc
     */
    [Event(name="progress", type="mx.events.ModuleEvent")]
    /**
     * @inheritDoc
     */
    [Event(name="ready", type="mx.events.ModuleEvent")]
    /**
     * @inheritDoc
     */
    [Event(name="setup", type="mx.events.ModuleEvent")]
    /**
     * @inheritDoc
     */
    [Event(name="unload", type="mx.events.ModuleEvent")]


    /**
     * FabricationModuleLoader support modules using ModuleManager. This is not IFabricator
     * ( as FlexModuleLoader ) so you have to act on ModuleEvent.READY event and attach
     * FlexModuleLoader.flexModule as your module fabricator.
     * @author Rafał Szemraj
     */
    public class FabricationModuleLoader extends EventDispatcher implements IDisposable {


        private var _moduleInstance:FlexModule;
        private var _router:IRouter;
        private var _moduleAddress:IModuleAddress;
        private var _id:String;
        private var _moduleGroup:String = null;
        private var _moduleInfo:IModuleInfo;

        /**
         * @param router Irouter instance for module
         * @param moduleAddressOrGroup IModuleAddress instance or moduleGroup name ( String )
         */
        public function FabricationModuleLoader(router:IRouter, moduleAddressOrGroup:Object)
        {
            super();
            this.router = router;
            if (moduleAddressOrGroup is IModuleAddress)
                this.moduleAddress = moduleAddressOrGroup as IModuleAddress;
            else {
                this.moduleGroup = moduleAddressOrGroup as String;
            }

        }

        /**
         * Id for module
         * @param value
         */
        public function set id(value:String):void
        {
            _id = value;
        }

        /**
         * ModuleGroup for module
         * @param value
         */
        public function set moduleGroup(value:String):void
        {
            _moduleGroup = value;
        }

        /**
         * Router for module
         * @param value
         */
        public function set router(value:IRouter):void
        {
            _router = value;
        }

        /**
         * ModuleAddres for module
         * @param value
         */
        public function set moduleAddress(value:IModuleAddress):void
        {
            _moduleAddress = value;
        }

        /**
         * Returns flexModule as module fabricator. You should use it for adding to display list
         * @return FlexModule instance
         */
        public function get flexModule():FlexModule
        {

            return _moduleInstance;

        }

        /**
         * @inheritDoc
         */
        public function dispose():void
        {

            disposeModuleInfo();
            _router = null;
            _moduleAddress = null;
            _id = null;
            _moduleGroup = null;


        }

        /**
         * Loads module from given url
         * @param url module url address
         * @param applicationDomain target application domain
         */
        public function loadModule(url:String):void
        {

            _moduleInfo = ModuleManager.getModule(url);
            _moduleInfo.addEventListener(ModuleEvent.READY, moduleReadyListener);
            _moduleInfo.addEventListener(ModuleEvent.ERROR, dispatchEvent);
            _moduleInfo.addEventListener(ModuleEvent.PROGRESS, dispatchEvent);
            _moduleInfo.addEventListener(ModuleEvent.SETUP, dispatchEvent);
            _moduleInfo.load( ApplicationDomain.currentDomain );
        }


        protected function moduleReadyListener(event:Event):void
        {
            var moduleFactory:IFlexModuleFactory =  retrieveModuleFactory( event );
            _moduleInstance = moduleFactory.create() as FlexModule;
            _moduleInstance.id = _id;
            _moduleInstance.router = _router;
            if (_moduleGroup) {

                _moduleInstance.moduleGroup = _moduleGroup;
                _moduleInstance.defaultRoute = _moduleGroup;

            }
            else if (_moduleAddress)
                _moduleInstance.defaultRouteAddress = _moduleAddress;
            disposeModuleInfo();
            dispatchEvent(new ModuleEvent(ModuleEvent.READY));
        }

        private function disposeModuleInfo():void
        {

            if (_moduleInfo) {

                _moduleInfo.removeEventListener(ModuleEvent.READY, moduleReadyListener);
                _moduleInfo.removeEventListener(ModuleEvent.ERROR, dispatchEvent);
                _moduleInfo.removeEventListener(ModuleEvent.PROGRESS, dispatchEvent);
                _moduleInfo.removeEventListener(ModuleEvent.SETUP, dispatchEvent);

            }
            _moduleInfo = null;
        }

        /**
         * Creates instance of flex module factory
         * @param event flash event instance
         * @return IFlexModuleFactory object
         */
        protected function retrieveModuleFactory( event:Event ):IFlexModuleFactory {

            return ( event as ModuleEvent ).module.factory;

        }


    }
}