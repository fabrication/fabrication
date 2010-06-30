package org.puremvc.as3.multicore.utilities.fabrication.injection.mock {
    import org.puremvc.as3.multicore.interfaces.IFacade;
    import org.puremvc.as3.multicore.utilities.fabrication.injection.MediatorInjector;

    public class MediatorInjectorMock extends MediatorInjector {


        public function MediatorInjectorMock(facade:IFacade, context:*)
        {
            super(facade, context);
        }

        public function elementExistMethod(elementName:String):Boolean {

			return elementExist( elementName );
		}

		public function getPatternElementForInjectionMethod(elementName:String, elementClass:Class ):Object {

			return getPatternElementForInjection( elementName, elementClass );
		}
    }
}