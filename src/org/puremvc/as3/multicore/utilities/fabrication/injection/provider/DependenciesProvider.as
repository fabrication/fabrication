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
    import flash.utils.Dictionary;


    [DefaultProperty("dependencies")]
    /**
     * Base implementation of IDependenciesProvider interface
     */
    public class DependenciesProvider implements IDependenciesProvider {


        private var _dependencies:Array = [];
        private var _dependenciesDict:Dictionary = new Dictionary( true );

        /**
         * adds any dependency object for further use
         * @param dependency dependency object
         * @param name name (id) of dependency object
         */
        public function addDependency(dependency:Object, name:String):void
        {
            if (!_dependenciesDict[name]) {

                _dependencies.push(dependency);
                _dependenciesDict[ name ] = dependency;
                
            }
        }

        /**
         * @inheritDoc
         */
        public function dispose():void
        {
            _dependencies = null;
            _dependenciesDict = null;
        }


        /**
         * @inheritDoc
         */
        public function getDependency(name:String):Object
        {
            if (_dependenciesDict[name]) {

               return  _dependenciesDict[name];
            }
            else if( hasOwnProperty( name )) {

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