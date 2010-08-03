package org.puremvc.as3.multicore.utilities.fabrication.injection.mock {
    import org.puremvc.as3.multicore.utilities.fabrication.injection.InjectionField;
    import org.puremvc.as3.multicore.utilities.fabrication.injection.ProxyInjector;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacade;

    public class ProxyInjectorMock extends ProxyInjector {


        public function ProxyInjectorMock(facade:FabricationFacade, context:*)
        {
            super(facade, context);
        }

        public function elementExistMethod(elementName:String):Boolean
        {
            return elementExist(elementName);
        }

        public function getPatternElementForInjectionMethod(elementName:String, elementClass:Class):Object
        {
            return getPatternElementForInjection(elementName, elementClass);
        }

        public function getElementNameMethod(field:InjectionField):String
        {
            return getElementName(field);
        }

    }
}