package org.puremvc.as3.multicore.utilities.fabrication.components.test {
    import flash.events.Event;

    import mx.events.FlexEvent;

    import org.puremvc.as3.multicore.utilities.fabrication.addons.TestFlexModule;
    import org.puremvc.as3.multicore.utilities.fabrication.components.*;
    import org.puremvc.as3.multicore.utilities.fabrication.routing.Router;

    public class FlexModuleTest extends AbstractApplicationTest {


        override protected function initializeFabrication():void
        {

            fabrication = new TestFlexModule();
            fabrication.router = new Router();
        }


        override protected function getReadyEvent():Event
        {
            return new FlexEvent(FlexEvent.INITIALIZE);
        }

        [Test]
        public function flexModuleHasValidType():void
        {
            assertType(FlexModule, fabrication);
        }
    }
}