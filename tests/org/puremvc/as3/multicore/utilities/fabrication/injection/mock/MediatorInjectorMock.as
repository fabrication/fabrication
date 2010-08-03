package org.puremvc.as3.multicore.utilities.fabrication.injection.mock {
    import org.puremvc.as3.multicore.utilities.fabrication.injection.MediatorInjector;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacade;

    public class MediatorInjectorMock extends MediatorInjector {


        public function MediatorInjectorMock(facade:FabricationFacade, context:*)
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
    }
}