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
    import mx.rpc.AbstractService;

    import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacade;
    import org.puremvc.as3.multicore.utilities.fabrication.services.FabricationMockService;

    /**
     * DependencyInjector for RPC services
     * @author Rafał Szemraj
     */
    public class ServiceInjector extends DependencyInjector {


        public function ServiceInjector(facade:FabricationFacade, context:*)
        {
            super(facade, context );
            injectionMetadataTagName = "InjectService";
        }

        /**
         * @inheritDoc
         */
        override protected function getPatternElementForInjection(elementName:String, elementClass:Class):Object
        {

            var service:AbstractService = super.getPatternElementForInjection( elementName, elementClass ) as AbstractService;
            if (service is FabricationMockService) {
                ( service as FabricationMockService).performInjections(facade);
            }
            return service;
        }


    }
}