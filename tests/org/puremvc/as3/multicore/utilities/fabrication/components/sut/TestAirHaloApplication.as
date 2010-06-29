package org.puremvc.as3.multicore.utilities.fabrication.components.sut {
    import org.puremvc.as3.multicore.utilities.fabrication.components.AirHaloApplication;

    public class TestAirHaloApplication extends AirHaloApplication {
        public function TestAirHaloApplication()
        {
            super();
        }

        override public function getStartupCommand():Class
        {
            return TestApplicationStartupCommand;
        }
    }
}