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

    /**
     * VO class to hold information about property descirbed
     * by Fabrication injection metatag
     * @author Rafał Szemraj
     */
    public class InjectionField {

        /**
         * Property name
         */
        public var fieldName:String;
        /**
         * Information if element of injection is typed
         * as class or interface
         */
        public var elementTypeIsInterface:Boolean = false;

        /**
         * Type of element of injection
         */
        public var elementClass:Class;

        /**
         * Name od element ( argument 'name' of injection metatag )
         */
        public var elementName:String = null;

    }


}