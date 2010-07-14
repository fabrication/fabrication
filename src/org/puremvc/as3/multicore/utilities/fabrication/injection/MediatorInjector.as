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
    import org.puremvc.as3.multicore.interfaces.IMediator;

    /**
     * Injector implementation for PurMVC mediators
     * @author Rafał Szemraj
     */
    public class MediatorInjector extends Injector {


        public function MediatorInjector(facade:IFacade, context:* )
        {
            super(facade, context, INJECT_MEDIATOR );
        }

        /**
         * @inheritDoc
         */
		override protected function elementExist(elementName:String):Boolean {

			return null != elementName && facade.hasMediator(elementName);
		}

        /**
         * Returns name of element to be injected. Because here we are looking for registered mediator
         * we can ommit metadata "name" param and try to retrieve mediator by static NAME property of
         * field class
         * @param field field instance to process
         * @param tagName name of injection tag
         */
		override protected function getPatternElementForInjection(elementName:String, elementClass:Class ):Object {

            var mediator:IMediator = facade.retrieveMediator( elementName ) as IMediator;
            if( mediator && ( mediator is elementClass ) )
			    return mediator;
            else
                return null;
		}
    }
}