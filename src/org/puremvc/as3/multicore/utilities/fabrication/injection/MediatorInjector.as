package org.puremvc.as3.multicore.utilities.fabrication.injection {
    import org.puremvc.as3.multicore.interfaces.IFacade;
    import org.puremvc.as3.multicore.interfaces.IMediator;

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