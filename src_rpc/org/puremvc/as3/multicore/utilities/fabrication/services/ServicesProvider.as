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

package org.puremvc.as3.multicore.utilities.fabrication.services {
    import mx.rpc.AbstractService;

    import org.puremvc.as3.multicore.utilities.fabrication.injection.provider.DependencyProvider;
    import org.puremvc.as3.multicore.utilities.fabrication.injection.provider.IDependencyProvider;

    [DefaultProperty("services")]
    public class ServicesProvider implements IDependencyProvider {

        private var _services:Array = [];


        public function addService(service:AbstractService, serviceName:String):void
        {

            if (!hasOwnProperty(serviceName)) {

                _services.push(service);
                this[ serviceName ] = service;
            }
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

        /**
         * @inheritDoc
         */
        public function dispose():void
        {
            _services = null;
        }

        /**
         * Returns array of services ( mx.rpc.AbstractService implementations )
         * @return
         */
        public function get services():Array
        {
            return _services;
        }


        [ArrayElementType("mx.rpc.AbstractService")]
        /**
         * Sets array of services
         */
        public function set services(value:Array):void
        {
            _services = value;
        }
    }
}