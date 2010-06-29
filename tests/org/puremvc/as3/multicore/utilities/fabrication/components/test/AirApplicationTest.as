package org.puremvc.as3.multicore.utilities.fabrication.components.test {
    import flash.events.Event;

    import mx.core.FlexGlobals;
    import mx.events.FlexEvent;

    import org.puremvc.as3.multicore.utilities.fabrication.components.*;

    public class AirApplicationTest extends AbstractApplicationTest {

        override protected function initializeFabrication():void
        {
            fabrication = FlexGlobals.topLevelApplication as AirHaloApplication;
        }


        override protected function getReadyEvent():Event
        {
            return new FlexEvent(FlexEvent.CREATION_COMPLETE);
        }
    }
}