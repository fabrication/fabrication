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
    import org.puremvc.as3.multicore.interfaces.IFacade;
    import org.puremvc.as3.multicore.interfaces.IProxy;

    /**
     * Injector implementation for PurMVC proxies
     * @author Rafał Szemraj
     */
    public class ProxyInjector extends Injector {


        public function ProxyInjector(facade:IFacade, context:*)
        {
            super(facade, context, INJECT_PROXY );
        }

        /**
         * @inheritDoc
         */
        override protected function elementExist(elementName:String):Boolean
        {

            return null != elementName;
        }

        /**
         * @inheritDoc
         */
        override protected function getPatternElementForInjection(elementName:String, elementClass:Class):Object
        {

            var proxy:IProxy = facade.retrieveProxy( elementName ) as IProxy;
            if( proxy && ( proxy is elementClass ) )
			    return proxy;
            else
                return null;
        }


    }
}