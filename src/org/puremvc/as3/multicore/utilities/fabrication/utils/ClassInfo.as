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

package org.puremvc.as3.multicore.utilities.fabrication.utils {
    import flash.system.ApplicationDomain;
    import flash.utils.describeType;
    import flash.utils.getQualifiedClassName;

    /**
	 * Utility to gather class info accross domains.
	 *
	 * @author Rafał Szemraj
	 */
    public class ClassInfo {


        protected var description:XML;
        private var _clazz:Class;
        protected var context:*;


        public function ClassInfo(context:*, applicationDomain:ApplicationDomain = null)
        {

            this.context = context;
            description = describeType(getClass(context, applicationDomain));

        }

        /**
         * Checks if given type is interface
         * @param type type to check
         * @return <b>true</b> if type is interface, otherwise <b>false</b>
         */
        public static function checkTypeIsIneterface(type:Class):Boolean
        {

            var typeDescription:XML = describeType( type );
            return typeDescription.factory.extendsClass.length() == 0;

        }

        /**
         * Returns class instance for given context and application domain ( optionally )
         * @param context object or sting ( type name )
         * @param applicationDomain application domain object ( optional )
         * @return
         */
        protected function getClass(context:*, applicationDomain:ApplicationDomain = null):Class
        {

            if (context is Class) {

                _clazz = context as Class;

            }

            else {
                applicationDomain = (applicationDomain == null) ? ApplicationDomain.currentDomain : applicationDomain;
                var className:String = context is String ? "" + context : getQualifiedClassName(context);
                
                if (!applicationDomain) {
                    applicationDomain = ApplicationDomain.currentDomain;
                }

                while (!applicationDomain.hasDefinition(className)) {
                    if (applicationDomain.parentDomain) {
                        applicationDomain = applicationDomain.parentDomain;
                    }
                    else {
                        break;
                    }
                }

                try {
                    _clazz = applicationDomain.getDefinition(className) as Class;
                }
                catch (e:ReferenceError) {
                    throw new Error("A class with the name '" + className + "' could not be found.");
                }
            }
            return clazz;
        }

        /**
         * Returns resolved class Object
         * @return Class object
         */
        public function get clazz():Class
        {
            return _clazz;
        }
    }
}