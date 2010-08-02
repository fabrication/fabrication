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

package org.puremvc.as3.multicore.utilities.fabrication.injection.provider {


    [DefaultProperty("dependencies")]
    /**
     * Base implementation of IDependenciesProvider interface
     */
    public class DependenciesProvider implements IDependenciesProvider {


        private var _dependencies:Array = [];

        /**
         * adds any dependency object for further use
         * @param dependency dependency object
         * @param name name (id) of dependency object
         */
        public function addDependency(dependency:Object, name:String):void
        {
            if (!hasOwnProperty(name)) {

                dependencies.push(dependency);
                this[ name ] = dependency;
            }
        }

        /**
         * @inheritDoc
         */
        public function dispose():void
        {
            dependencies = null;
        }


        /**
         * @inheritDoc
         */
        public function getDependency(name:String):Object
        {
            if (hasOwnProperty(name)) {

                return this[ name ];
            }
            return null;
        }

        protected function get dependencies():Array
        {
            return _dependencies;
        }

        protected function set dependencies(value:Array):void
        {
            _dependencies = value;
        }


    }
}