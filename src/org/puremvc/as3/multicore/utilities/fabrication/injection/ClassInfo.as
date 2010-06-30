package org.puremvc.as3.multicore.utilities.fabrication.injection {
    import flash.system.ApplicationDomain;
    import flash.utils.describeType;
    import flash.utils.getQualifiedClassName;

    public class ClassInfo {


        private var description:XML;
        private var _clazz:Class;


        public function ClassInfo(context:*, applicationDomain:ApplicationDomain = null)
        {

            description = describeType(getClass(context, applicationDomain));

        }


        public function getInjectionFieldsByInjectionType(injectionType:String):Vector.<InjectionField>
        {

            var fields:Vector.<InjectionField> = new Vector.<InjectionField>();

            var variables:XMLList = description..variable;
            var metadata:XML;
            var metadataName:XML;
            for each(var variable:XML in variables) {

                metadata = variable.metadata.(@name == injectionType )[0] as XML;
                if (metadata) {

                    var field:InjectionField = new InjectionField();
                    field.fieldName = "" + variable.@name;
                    field.elementClass = getClass( ""+variable.@type );
                    field.elementTypeIsInterface = checkTypeIsIneterface( field.elementClass );
                    metadataName = metadata.arg.(attribute("key") == "name" )[0] as XML;
                    if (metadataName) {

                        field.elementName = "" + metadataName.@value;
                    }
                    fields.push(field)
                }

            }
            return fields;


        }

        private function checkTypeIsIneterface(type:Class):Boolean
        {

            var typeDescription:XML = describeType( type );
            return typeDescription.factory.extendsClass.length() == 0;

        }

        private function getClass(context:*, applicationDomain:ApplicationDomain = null):Class
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

        public function get clazz():Class
        {
            return _clazz;
        }
    }
}