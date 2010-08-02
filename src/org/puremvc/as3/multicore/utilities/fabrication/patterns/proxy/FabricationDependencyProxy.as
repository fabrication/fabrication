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

package org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy {
    import org.puremvc.as3.multicore.utilities.fabrication.injection.provider.IDependenciesProvider;

    final public class FabricationDependencyProxy extends FabricationProxy {


        static public const NAME:String = "FabricationDependencyProxy";

        [ArrayElementType( "org.puremvc.as3.multicore.utilities.fabrication.injection.provider.IDependenciesProvider" )]
        private var _dependenciesyProviders:Array = [];

        public function FabricationDependencyProxy()
        {
            super(NAME);
        }

        /**
         * @inheritDoc
         */
        override public function dispose():void
        {
            for each(var dependenciesProvider:IDependenciesProvider in _dependenciesyProviders) {

                dependenciesProvider.dispose();

            }
            _dependenciesyProviders = null;
            super.dispose();
        }

        /**
         * adds dependency provider ( class or instance ) to proxy
         * @param dependenciesProvider class or instance of IDependenciesProvider
         */
        public function addDependencyProvider(dependenciesProvider:*):void
        {

            if (dependenciesProvider is IDependenciesProvider)
                _dependenciesyProviders.push(dependenciesProvider);
            else if (dependenciesProvider is Class) {

                var dependenciesProviderClass:Class = dependenciesProvider as Class;
                var dProvider:IDependenciesProvider = ( new dependenciesProviderClass ) as IDependenciesProvider;
                if (dProvider)
                    _dependenciesyProviders.push(dProvider);


            }


        }

        /**
         * returns dependency object by its name (id) or null if object cannot be found.
         * @param name name of dependency object
         * @return dependency object
         */
        public function getDependency(name:String):Object
        {

            var dependency:Object;
            for each(var dependenciesProvider:IDependenciesProvider in _dependenciesyProviders) {

                dependency = dependenciesProvider.getDependency(name);
                if (dependency)
                    return dependency;

            }
            return null;

        }

    }
}