package org.puremvc.as3.multicore.utilities.fabrication.injection.mock {
    import com.anywebcam.mock.Mock;

    import org.puremvc.as3.multicore.interfaces.IFacade;
    import org.puremvc.as3.multicore.utilities.fabrication.addons.IMockable;
    import org.puremvc.as3.multicore.utilities.fabrication.injection.Injector;

    public class InjectorMock extends Injector implements IMockable {

        private var _mock:Mock;


        public function InjectorMock( facade:IFacade, context:*, injectionMetadataTagName:String)
        {
            super( facade, context, injectionMetadataTagName);
        }


        public function get mock():Mock
        {
            return _mock ? _mock : _mock = new Mock( this, true );
        }


        override protected function elementExist(elementName:String):Boolean
        {
            return mock.elementExist(elementName);
        }


        override protected function getPatternElementForInjection(elementName:String, elementClass:Class):Object
        {
            return mock.getPatternElementForInjection(elementName, elementClass);
        }
    }
}