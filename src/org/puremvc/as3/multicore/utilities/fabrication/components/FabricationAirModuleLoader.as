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
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.events.Event;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;
    import flash.utils.ByteArray;

    import mx.core.IFlexModuleFactory;
    import mx.events.ModuleEvent;

    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouter;

    /**
     * FabricationModuleLoader adds support for loading modules into Air application
     * @author Rafał Szemraj
     */
    public class FabricationAirModuleLoader extends FabricationModuleLoader {


        public function FabricationAirModuleLoader(router:IRouter, moduleAddressOrGroup:Object)
        {
            super(router, moduleAddressOrGroup);
        }

        /**
         * @inheritDoc
         */
        override public function loadModule(url:String, applicationDomain:ApplicationDomain = null):void
        {

            var moduleURLRequest:URLRequest = new URLRequest(url);
            var moduleURLLoader:URLLoader = new URLLoader();
            moduleURLLoader.dataFormat = URLLoaderDataFormat.BINARY;
            moduleURLLoader.load(moduleURLRequest);
            moduleURLLoader.addEventListener(Event.COMPLETE, moduleURLLoaderCompleteHandler);

        }

        private function moduleURLLoaderCompleteHandler(event:Event):void
        {

            var context:LoaderContext = new LoaderContext();

            //
            context.allowLoadBytesCodeExecution = true;
            context.applicationDomain = ApplicationDomain.currentDomain;
            //

            var moduleBytesLoader:Loader = new Loader();
            moduleBytesLoader.loadBytes(( event.target as URLLoader ).data as ByteArray, context);
            moduleBytesLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, moduleBytesLoaderCompleteHandler);
        }

        private function moduleBytesLoaderCompleteHandler(event:Event):void
        {
            var moduleBytesLoaderInfo:LoaderInfo = LoaderInfo(event.target);
            moduleBytesLoaderInfo.content.addEventListener(ModuleEvent.READY, moduleReadyListener);
        }

        /**
         *
         * @inheritDoc
         * @see FabricationModuleLoader#retrieveModuleFactory
         * 
         */
        override protected function retrieveModuleFactory( event:Event ):IFlexModuleFactory {

            return IFlexModuleFactory( event.target );

        }
    }
}