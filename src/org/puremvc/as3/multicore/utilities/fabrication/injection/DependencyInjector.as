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

package org.puremvc.as3.multicore.utilities.fabrication.injection {
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacade;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationDependencyProxy;

    /**
     * Injector implementation for common dependency objects ( no PureMVC related )
     * @author Rafał Szemraj
     */
    public class DependencyInjector extends Injector {

        private static const INJECT:String = "Inject";

        protected var dependencyProxy:FabricationDependencyProxy;

        public function DependencyInjector(facade:FabricationFacade, context:*)
        {
            super(facade, context, INJECT);
            dependencyProxy = facade.retrieveProxy(FabricationDependencyProxy.NAME) as FabricationDependencyProxy;
        }


        /**
         * @inheritDoc
         */
        override protected function elementExist(elementName:String):Boolean
        {
            return dependencyProxy.getDependency(elementName) != null;

        }

        /**
         * @inheritDoc
         */
        override protected function getPatternElementForInjection(elementName:String, elementClass:Class):Object
        {
            var element:Object = dependencyProxy.getDependency(elementName);
            if (element && ( element is elementClass)) {

                return element;

            }
            else
                return null;
        }
    }
}